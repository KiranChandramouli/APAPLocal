SUBROUTINE REDO.STO.NCF.UPDATE(VAR.NCF.REQ,VAR.CURRENCY,VAR.CHARGE.AMOUNT,VAR.TAX.AMOUNT)
*-----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will write the NCF and charge details in FT local Fields
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : Riyas
* PROGRAM NAME : REDO.STO.NCF.UPDATE
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                     REFERENCE       DESCRIPTION
* 22.07.2014    Riyas                                   INITIAL CREATION
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*-------
PROCESS:
*-------

    WCOMM.TYPE = CHANGE(WCOMM.TYPE,@VM,@FM)
    WCOMM.AMT  = CHANGE(WCOMM.AMT,@VM,@FM)
    WCHRG.AMT  = 0
    Y.COMM.AMT = 0

    WX = 0
    WY = 0
    Y.CNT = 1
    LOOP
        REMOVE COMM.TYPE FROM WCOMM.TYPE SETTING TR.POS
    WHILE COMM.TYPE : TR.POS DO

        GOSUB GET.CHARGE.TYPE

        IF WTAX.FLAG EQ "C" THEN

            WX += 1
            R.NEW(FT.LOCAL.REF)<1,COMM.COD.POS,WX> = COMM.TYPE
            R.NEW(FT.LOCAL.REF)<1,WV.COMM.POS,WX>  = "NO"
            Y.LEN.AMT  = LEN(WCOMM.AMT<Y.CNT>)
            Y.COMM.AMT = WCOMM.AMT<Y.CNT>[4,Y.LEN.AMT]
            R.NEW(FT.LOCAL.REF)<1,COMM.AMT.POS,WX> = Y.COMM.AMT

            VAR.CHARGE.AMOUNT += Y.COMM.AMT

        END ELSE

            WY += 1
            R.NEW(FT.LOCAL.REF)<1,TAX.CODE.POS,WY>   = COMM.TYPE
            R.NEW(FT.LOCAL.REF)<1,WV.TAX.POS,WY>     = "NO"
            Y.LEN.AMT  = LEN(WCOMM.AMT<Y.CNT>)
            Y.COMM.AMT = WCOMM.AMT<Y.CNT>[4,Y.LEN.AMT]
            R.NEW(FT.LOCAL.REF)<1,TAX.AMT.POS,WY>    = Y.COMM.AMT

            VAR.TAX.AMOUNT += Y.COMM.AMT

        END

        IF WCOMM.CODE NE 'WAIVE' THEN
            WCHRG.AMT += Y.COMM.AMT
        END ELSE
            R.NEW(FT.LOCAL.REF)<1,L.TT.WV.TAX.AMT.POS> += Y.COMM.AMT
        END

        Y.CNT += 1
    REPEAT


    IF WCOMM.CODE EQ "DEBIT PLUS CHARGES" OR WCOMM.CODE EQ "" THEN
        R.NEW(FT.LOCAL.REF)<1,L.TT.TRANS.AMT.POS>  = Y.AMOUNT + WCHRG.AMT
    END ELSE
        R.NEW(FT.LOCAL.REF)<1,L.TT.TRANS.AMT.POS>  = Y.AMOUNT
    END

RETURN
*
* ==============
GET.CHARGE.TYPE:
* ==============
*
    WTAX.FLAG = ""
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, COMM.TYPE, R.FT.COMMISSION.TYPE, ERR.CT)
    IF R.FT.COMMISSION.TYPE THEN
        WTAX.FLAG = R.FT.COMMISSION.TYPE<FT4.LOCAL.REF,FTCT.TX.POS>
    END

RETURN
*----
INIT:
*----
    PROCESS.GOAHEAD = "1"

    WAPP.LST   = "FUNDS.TRANSFER" : @FM : "FT.COMMISSION.TYPE"
    WCAMPO<1>  = "L.TT.COMM.CODE"
    WCAMPO<2>  = "L.TT.TAX.CODE"
    WCAMPO<3>  = "L.TT.WV.TX.AMT"
    WCAMPO<4>  = "L.TT.WV.COMM"
    WCAMPO<5>  = "L.TT.COMM.AMT"
    WCAMPO<6>  = "L.TT.WV.TAX"
    WCAMPO<7>  = "L.TT.TAX.AMT"
    WCAMPO<8>  = "L.FT.COMM.CODE"         ;* Added by Vignesh
    WCAMPO<9>  = "L.TT.TRANS.AMT"
    WCAMPO<10> = "L.TT.WV.TAX.AMT"
    WCAMPO<11> = "L.NCF.REQUIRED"
    WCAMPO<12> = "L.NCF.NUMBER"

    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO

    WCAMPO    = "L.FT4.TX.CMM.FL"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST := @FM : WCAMPO

    YPOS=''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)

    COMM.COD.POS   = YPOS<1,1>
    TAX.CODE.POS   = YPOS<1,2>
    WV.TAX.AMT.POS = YPOS<1,3>
    WV.COMM.POS    = YPOS<1,4>
    COMM.AMT.POS   = YPOS<1,5>
    WV.TAX.POS     = YPOS<1,6>
    TAX.AMT.POS    = YPOS<1,7>
    L.FT.COMM.TYPE.POS  = YPOS<1,8>
    L.TT.TRANS.AMT.POS  = YPOS<1,9>
    L.TT.WV.TAX.AMT.POS = YPOS<1,10>
    L.NCF.REQUIRED.POS  = YPOS<1,11>
    L.NCF.NUMBER.POS    = YPOS<1,12>
    FTCT.TX.POS         = YPOS<2,1>

    FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE"
    F.FT.COMMISSION.TYPE  = ""

    Y.AMOUNT  =  R.NEW(FT.DEBIT.AMOUNT)
    VAR.CURRENCY = R.NEW(FT.DEBIT.CURRENCY)
    IF Y.AMOUNT EQ '' THEN
        Y.AMOUNT   = R.NEW(FT.CREDIT.AMOUNT)
        VAR.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
    END
    VAR.NCF.REQ = R.NEW(FT.LOCAL.REF)<1,L.NCF.REQUIRED.POS>

RETURN

*----------
OPEN.FILES:
*----------

    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
RETURN

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------

    WCOMM.CODE = R.NEW(FT.COMMISSION.CODE)
    WCOMM.TYPE = R.NEW(FT.COMMISSION.TYPE)
    WCOMM.AMT  = R.NEW(FT.COMMISSION.AMT)
    IF WCOMM.TYPE EQ "" THEN
        PROCESS.GOAHEAD = ""
    END

RETURN
END
