* @ValidationCode : MjotMjI1OTEwODA6Q3AxMjUyOjE2ODI1MTg4ODcyODk6SVRTUzotMTotMTotMzY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 19:51:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -36
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.WV.COMM.TAX
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.V.VAL.WV.COMM.TAX
*---------------------------------------------------------------------------------

*DESCRIPTION       :Input routine attached to Teller version to validate commission
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
*   28-NOV-2011        Pradeep S     PACS00163682         Initial Creation
*   30-JAN-2012        J.COSTA C.    PACS00163682         Modifications on TAX and COMM waive
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM, F.READ TO CACHE.READ
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_TT.COMMON
    $INSERT I_TT.EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.TELLER.TRANSACTION
*
    $INSERT I_F.REDO.MULTITXN.PARAMETER
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN  ;* Return END
*
* ======
PROCESS:
* ======
*
    IF AV EQ Y.L.TT.WV.COMM THEN
        GOSUB PROCESS.COMM
    END

    IF AV EQ Y.L.TT.WV.TAX THEN
        GOSUB PROCESS.TAX
    END

    CALL TT.GENERAL.LIBRARY(CALL.CALCULATE.NET.AMOUNT)

    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
        IF R.NEW(TT.TE.CURRENCY.1) EQ LCCY THEN
            R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>  = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        END ELSE
            R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>  = R.NEW(TT.TE.AMOUNT.FCY.1)
        END
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
    END ELSE
        IF R.NEW(TT.TE.CURRENCY.1) EQ LCCY THEN
            R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        END ELSE
            R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.AMOUNT.FCY.1)
        END
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
    END
*
    WAMOUNT.DB = R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>
    WAMOUNT.CR = R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>
*
    IF WTM.SIGN EQ "DEBIT" THEN
        IF WTM.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.DB * -1
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.CR
        END
    END ELSE
        IF WTM.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.CR
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.DB * -1
        END
    END
*
    IF V$FUNCTION EQ "D" THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END
*
    R.NEW(TT.TE.LOCAL.REF)<1,TRAN.AMT.POS> = WTRAN.AMOUNT
*
RETURN  ;* Return PROCESS
*
* ===========
PROCESS.COMM:
* ===========
*
    Y.WV.COMM.VAL = COMI

    IF Y.WV.COMM.VAL EQ "YES" THEN
        Y.COMM.TAX.CODE = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.COMM.CODE,AS>
        GOSUB DELETE.CHG.VALUE
    END

    IF Y.WV.COMM.VAL EQ "NO" THEN
        Y.COMM.TAX.CODE = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.COMM.CODE,AS>
        Y.COMM.TAX.AMT  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.COMM.AMT,AS>
        GOSUB INSERT.CHG.VALUE
    END

RETURN  ;*PROCESS.COMM
*
* ==========
PROCESS.TAX:
* ==========
*
    WTAX.AMT.WAIVED = 0
    Y.WV.TAX.VAL = COMI

    IF Y.WV.TAX.VAL EQ "YES" THEN
        Y.COMM.TAX.CODE  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.TAX.CODE,AS>
        WTAX.AMT.WAIVED  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.TAX.AMT,AS>
        GOSUB DELETE.CHG.VALUE
    END

    IF Y.WV.TAX.VAL EQ "NO" THEN
        Y.COMM.TAX.CODE = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.TAX.CODE,AS>
        Y.COMM.TAX.AMT  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.TAX.AMT,AS>
        GOSUB INSERT.CHG.VALUE
    END

RETURN  ;*PROCESS.TAX
*
* ===============
DELETE.CHG.VALUE:
* ===============
*
    Y.CHG.CODE = R.NEW(TT.TE.CHARGE.CODE)
*
* PACS00244873 - S
    GOSUB GET.FTCT.DTLS
    IF Y.FTCT.CT EQ "" THEN
        ETEXT = 'TT-REDO.FTCT.COMTX.FLG.MISS-&':@FM:Y.LOC.APPL<2> ;*R22 AUTO CONVERSION
        CALL STORE.END.ERROR
        RETURN
    END
* PACS00244873 - E
*
    LOCATE Y.COMM.TAX.CODE IN Y.CHG.CODE<1,1> SETTING COMM.POS THEN
        DEL R.NEW(TT.TE.CHARGE.CUSTOMER)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHARGE.ACCOUNT)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHARGE.CATEGORY)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHRG.DR.TXN.CDE)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHRG.CR.TXN.CDE)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHRG.AMT.LOCAL)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHRG.AMT.FCCY)<1,COMM.POS>
        DEL R.NEW(TT.TE.CHARGE.CODE)<1,COMM.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT> += WTAX.AMT.WAIVED
    END
    IF R.NEW(TT.TE.CHARGE.CODE) EQ "" THEN
        R.NEW(TT.TE.WAIVE.CHARGES) = "YES"
    END
*
RETURN  ;*Return DELETE.CHG.VALUE
*
* ===============
INSERT.CHG.VALUE:
* ===============
*
    Y.CHG.CODE = R.NEW(TT.TE.CHARGE.CODE)
    LOCATE Y.COMM.TAX.CODE IN Y.CHG.CODE<1,1> SETTING COMM.POS ELSE
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
            R.NEW(TT.TE.CHARGE.ACCOUNT)<1,-1>  = R.NEW(TT.TE.ACCOUNT.1)
        END ELSE
            R.NEW(TT.TE.CHARGE.ACCOUNT)<1,-1>  = R.NEW(TT.TE.ACCOUNT.2)
        END
        GOSUB GET.FTCT.DTLS
        R.NEW(TT.TE.CHARGE.CATEGORY)<1,-1> = Y.CATEG
        R.NEW(TT.TE.CHRG.DR.TXN.CDE)<1,-1> = Y.DR.CODE
        R.NEW(TT.TE.CHRG.CR.TXN.CDE)<1,-1> = Y.CR.CODE
        IF R.NEW(TT.TE.CURRENCY.2) EQ LCCY THEN
            R.NEW(TT.TE.CHRG.AMT.LOCAL)<1,-1>  = Y.COMM.TAX.AMT
            R.NEW(TT.TE.CHRG.AMT.FCCY)<1,-1>   = ''
        END ELSE
            R.NEW(TT.TE.CHRG.AMT.LOCAL)<1,-1>  = ''
            R.NEW(TT.TE.CHRG.AMT.FCCY)<1,-1>   = Y.COMM.TAX.AMT
        END
        R.NEW(TT.TE.CHARGE.CODE)<1,-1>     = Y.COMM.TAX.CODE
*        R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT> -= Y.COMM.TAX.AMT ;* VNL - 2012JAN30
        IF  R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT> GE Y.COMM.TAX.AMT THEN
            R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT> -= Y.COMM.TAX.AMT
        END
    END
    R.NEW(TT.TE.WAIVE.CHARGES) = "NO"
*
RETURN  ;*Return INSERT.CHG.VALUE
*
* ============
GET.FTCT.DTLS:
* ============
*
    R.FTCT = ''     ; Y.CATEG = ''
    Y.DR.CODE = ''  ; Y.CR.CODE = ''
    Y.AMT.LLCY = '' ; Y.AMT.FCCY = '' ; Y.FTCT.CT = ''

    CALL CACHE.READ(FN.FTCT, Y.COMM.TAX.CODE, R.FTCT, ERR.FTCT) ;*R22 AUTO CONVERSION
    IF R.FTCT THEN
        Y.CATEG   = R.FTCT<FT4.CATEGORY.ACCOUNT>
        Y.DR.CODE = R.FTCT<FT4.TXN.CODE.DR>
        Y.CR.CODE = R.FTCT<FT4.TXN.CODE.DR>
        Y.FTCT.CT = R.FTCT<FT4.LOCAL.REF,Y.L.FT.COMTAX.FLG>
    END

RETURN  ;*Return GET.FTCT.DTLS
*
* =======
GET.SIDE:
* =======
*
    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""
*
    FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
    F.REDO.MULTITXN.PARAMETER  = ""
*
    WTT.TRANS          = R.NEW(TT.TE.TRANSACTION.CODE)
*
    CALL CACHE.READ(FN.TELLER.TRANSACTION, WTT.TRANS, R.TELLER.TRANSACTION, ERR.MSJ) ;*R22 AUTO CONVERSION
    IF R.TELLER.TRANSACTION THEN
        WCATEG1  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
        WCATEG2  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.2>
        WTRCODE1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        WTRCODE2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
    END

    WRMP.ID      = "SYSTEM"
*
    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)
    WCATEG.CHECK = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CHECK>
    WCATEG.CASH  = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CASH>
    WCHECK.TRAN  = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.TRANSACT>
*
    WTM.SIDE   = ""
    IF WTRCODE1 EQ WCHECK.TRAN THEN
        WTM.SIDE   = "1"
    END ELSE
        IF WTRCODE2 EQ WCHECK.TRAN THEN
            WTM.SIDE   = "2"
        END
    END
*
    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
        WTM.SIDE       = "1"
    END ELSE
        LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
            WTM.SIDE       = "2"
        END
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1

    Y.LOC.APPL = "TELLER":@FM:"FT.COMMISSION.TYPE" ;*R22 AUTO CONVERSION START
    Y.LOC.FLD  = "L.TT.COMM.CODE":@VM:"L.TT.WV.COMM":@VM:"L.TT.COMM.AMT"
    Y.LOC.FLD := @VM:"L.TT.TAX.CODE":@VM:"L.TT.WV.TAX":@VM:"L.TT.TAX.AMT"
    Y.LOC.FLD := @VM:"L.TT.WV.TAX.AMT":@VM:'L.TT.BASE.AMT':@VM:'L.TT.TRANS.AMT'
    Y.LOC.FLD := @VM:"L.DEBIT.AMOUNT"
    Y.LOC.FLD := @VM:"L.CREDIT.AMOUNT"
    Y.LOC.FLD := @VM:"L.TRAN.AMOUNT"
    Y.LOC.FLD := @FM:"L.FT4.TX.CMM.FL" ;*R22 AUTO CONVERSION END

    Y.LOC.POS = ''

    CALL MULTI.GET.LOC.REF(Y.LOC.APPL,Y.LOC.FLD,Y.LOC.POS)
    Y.L.TT.COMM.CODE    = Y.LOC.POS<1,1>
    Y.L.TT.WV.COMM      = Y.LOC.POS<1,2>
    Y.L.TT.COMM.AMT     = Y.LOC.POS<1,3>
    Y.L.TT.TAX.CODE     = Y.LOC.POS<1,4>
    Y.L.TT.WV.TAX       = Y.LOC.POS<1,5>
    Y.L.TT.TAX.AMT      = Y.LOC.POS<1,6>
    Y.L.TT.WV.TAX.AMT   = Y.LOC.POS<1,7>
    Y.L.TT.BASE.AMT     = Y.LOC.POS<1,8>
    Y.L.TT.TRANS.AMT    = Y.LOC.POS<1,9>
    DEBIT.POS           = Y.LOC.POS<1,10>
    CREDIT.POS          = Y.LOC.POS<1,11>
    TRAN.AMT.POS        = Y.LOC.POS<1,12>
    Y.L.FT.COMTAX.FLG   = Y.LOC.POS<2,1>
*
    WVAR.NAMES    = "CURRENT.SIDE"
    WVAR.VAL      = ""
    WPOS.X        = 0
*
    WTT.ID       = R.NEW(TT.TE.TELLER.ID.1)
    WTM.SIGN     = R.NEW(TT.TE.DR.CR.MARKER)
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAMES SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END
    REPEAT
*
    WTM.SIDE          = WVAR.VAL<1>
*
    IF WTM.SIDE EQ "" THEN
        GOSUB GET.SIDE
    END
*
RETURN  ;*Return INITIALISE
*
* =========
OPEN.FILES:
* =========
*
    FN.FTCT = 'F.FT.COMMISSION.TYPE'
    F.FTCT  = ''
    CALL OPF(FN.FTCT,F.FTCT)

RETURN  ;*Return OPEN.FILES
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF MESSAGE  EQ "VAL" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                IF COMI EQ "" THEN
                    PROCESS.GOAHEAD = ""
                    ETEXT = 'TT-INP.MISS'
                    CALL STORE.END.ERROR
                END

            CASE LOOP.CNT EQ 3
                IF COMI EQ "" THEN
                    PROCESS.GOAHEAD = ""
                    ETEXT = 'TT-INP.MISS'
                    CALL STORE.END.ERROR
                END

        END CASE

*       Increase
        LOOP.CNT += 1
*
    REPEAT
*


RETURN  ;* Return CHECK.PRELIM.CONDITIONS

END
