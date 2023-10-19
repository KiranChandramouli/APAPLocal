* @ValidationCode : MjotMjAyMTAzMjQxNTpDcDEyNTI6MTY4NTUzNjAxNzA3ODp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.WV.COMM.TAX
***********************************************************
*----------------------------------------------------------
* COMPANY NAME    : APAP
* DEVELOPED BY    : Pradeep S
* PROGRAM NAME    : REDO.V.AUTH.WV.COMM.TAX
*----------------------------------------------------------
* DESCRIPTION     : This routine is a auth routine attached to verisons
* TELLER's to post the accounting entry for the calculated TAX and COMM
*------------------------------------------------------------

* LINKED WITH    : TELLER AUTH ROUTINE
* IN PARAMETER   : NONE
* OUT PARAMETER  : NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO                  REFERENCE                                    DESCRIPTION
*  13.10.2011       Pradeep S           PACS00163682                             INITIAL CREATION
*10-04-2023         Conversion Tool      R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,F.READ TO CACHE.READ
*10-04-2023          Samaran T           R22 Manual Code conversion              CALL routine format modified
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.TELLER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $USING APAP.TAM
*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PRE.PROCESS

    IF PROCESS.GOHEAD THEN
        GOSUB PROCESS
    END
*
RETURN  ;* END

*********
PROCESS:
*********
*
    Y.COMMON.ARRAY = ""
    Y.TAX.CODE.CNT = DCOUNT(Y.WV.TAX.CODE,@FM)
    Y.TAX.CTR = 1
    LOOP
    WHILE Y.TAX.CTR LE Y.TAX.CODE.CNT
        IF Y.WV.TAX.YES.NO<Y.TAX.CTR> EQ "YES" THEN
            Y.TAX.AMT   = Y.WV.TAX.AMT<Y.TAX.CTR>
            Y.FTCT.ID   = Y.WV.TAX.CODE<Y.TAX.CTR>
            Y.ACCT.FLAG = @TRUE
            GOSUB CALC.TAX.AMT
            GOSUB GET.FTCT.DTLS
            GOSUB DR.ENTRY
            Y.COMMON.ARRAY<-1> = LOWER(R.CATEG.ENT)
            GOSUB CR.ENTRY
            Y.COMMON.ARRAY<-1> = LOWER(R.STMT.ARR)
        END
        Y.TAX.CTR += 1
    REPEAT
*
    IF Y.ACCT.FLAG THEN
        GOSUB EB.ACCOUNTING
    END
*
RETURN  ;* Return PROCESS
*
*************
CALC.TAX.AMT:
*************
*
    Y.TAX.AMT.FCY = ''
    Y.TAX.AMT.LCY = ''

    IF Y.TXN.CCY EQ LCCY THEN
        Y.TAX.AMT.LCY = Y.TAX.AMT
        Y.TAX.AMT.FCY = ''
    END

    IF Y.TXN.CCY NE LCCY THEN
        Y.TAX.AMT.FCY = Y.TAX.AMT
        Y.TAX.AMT.LCY = Y.TAX.AMT * Y.EXCHANGE.RATE
    END
*
RETURN  ;* Return CALC.TAX.AMT
*
**************
GET.FTCT.DTLS:
**************
*
    R.FTCT = ''
    CALL CACHE.READ(FN.FTCT, Y.FTCT.ID, R.FTCT, FTCT.ERR)   ;*R22 AUTO CODE CONVERSION
    IF R.FTCT THEN
        Y.TR.CODE.DR   = R.FTCT<FT4.TXN.CODE.CR>
        Y.TR.CODE.CR   = R.FTCT<FT4.TXN.CODE.DR>
        Y.TAX.ACCOUNT  = R.FTCT<FT4.CATEGORY.ACCOUNT>
        IF Y.TXN.CCY NE LCCY THEN
            Y.TAX.ACCT.FCY = ""
            Y.TAX.ACCT.FCY = Y.TXN.CCY : Y.TAX.ACCOUNT[4,13]
            Y.TAX.ACCOUNT  = Y.TAX.ACCT.FCY
            Y.WAIVE.CATEG  = R.FTCT<FT4.LOCAL.REF,POS.L.WAIVE.CATEG>
        END
    END
*
RETURN  ;* Return GET.FTCT.DTLS
*
*********
DR.ENTRY:
*********
*
    IF WAIVE.CAT EQ "" THEN
        WAIVE.CAT = Y.WAIVE.CATEG
    END
*
    R.CATEG.ENT                          = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER>   = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>     = ID.COMPANY
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = Y.TR.CODE.DR
    R.CATEG.ENT<AC.CAT.THEIR.REFERENCE>  = ''
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>      = Y.CUST.ID
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER>  = Y.ACCT.OFFICER
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = Y.ACCT.CATEGORY
    R.CATEG.ENT<AC.CAT.PL.CATEGORY>      = WAIVE.CAT
    R.CATEG.ENT<AC.CAT.VALUE.DATE>       = R.NEW(TT.TE.VALUE.DATE.2)<1,1>
    R.CATEG.ENT<AC.CAT.CURRENCY>         = Y.TXN.CCY
    R.CATEG.ENT<AC.CAT.POSITION.TYPE>    = 'TR'
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET>  = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE>  = ID.NEW
    R.CATEG.ENT<AC.CAT.SYSTEM.ID>        = "AC"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE>     = TODAY
    R.CATEG.ENT<AC.CAT.NARRATIVE>        = ''
    R.CATEG.ENT<AC.CAT.CRF.TYPE>         = "DEBIT"
*
    IF Y.TXN.CCY EQ LCCY THEN
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY>   = ''
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY>   = Y.TAX.AMT.LCY * '-1'
    END ELSE
        LCCY.TOT.AMT = "" ; DIFF.AMT = '' ; LCCY.AMT = '' ; RET.ERR = '' ; EX.RATE = ''
        Y.CCY = Y.TXN.CCY ; Y.AMT = Y.TAX.AMT.FCY ; TARGET.CCY = LCCY
        Y.CUR.MKT='1'
        CALL EXCHRATE(Y.CUR.MKT,Y.CCY,Y.AMT,TARGET.CCY,LCCY.TOT.AMT,'',EX.RATE,DIFF.AMT,LCCY.AMT,RET.ERR)
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = LCCY.TOT.AMT  * '-1'
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY> = Y.TAX.AMT.FCY * '-1'
    END
*
RETURN  ;* Return DR.ENTRY
*
*********
CR.ENTRY:
*********
*
    R.STMT.ARR                           = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER>    = Y.TAX.ACCOUNT
    R.STMT.ARR<AC.STE.COMPANY.CODE>      = ID.COMPANY
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>  = Y.TR.CODE.CR
    R.STMT.ARR<AC.STE.THEIR.REFERENCE>   = ''
    R.STMT.ARR<AC.STE.CUSTOMER.ID>       = Y.CUST.ID
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER>   = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY>  = Y.ACCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE>        = R.NEW(TT.TE.VALUE.DATE.1)<1,1>
    R.STMT.ARR<AC.STE.CURRENCY>          = Y.TXN.CCY
    R.STMT.ARR<AC.STE.POSITION.TYPE>     = 'TR'
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>   = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>   = '1'
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>   = ID.NEW
    R.STMT.ARR<AC.STE.SYSTEM.ID>         = "AC"
    R.STMT.ARR<AC.STE.BOOKING.DATE>      = TODAY
    R.STMT.ARR<AC.STE.CRF.TYPE>          = "CREDIT"
*
    IF Y.TXN.CCY EQ LCCY THEN
        R.STMT.ARR<AC.STE.AMOUNT.FCY>    = ''
        R.STMT.ARR<AC.STE.AMOUNT.LCY>        = Y.TAX.AMT.LCY
    END ELSE
        LCCY.TOT.AMT = "" ; DIFF.AMT = '' ; LCCY.AMT = '' ; RET.ERR = '' ; EX.RATE = ''
        Y.CCY = Y.TXN.CCY ; Y.AMT = Y.TAX.AMT.FCY ; TARGET.CCY = LCCY
        Y.CUR.MKT='1'
        CALL EXCHRATE(Y.CUR.MKT,Y.CCY,Y.AMT,TARGET.CCY,LCCY.TOT.AMT,'',EX.RATE,DIFF.AMT,LCCY.AMT,RET.ERR)
        R.STMT.ARR<AC.STE.AMOUNT.LCY>    = LCCY.TOT.AMT
        R.STMT.ARR<AC.STE.AMOUNT.FCY>    = Y.TAX.AMT.FCY
    END
*
RETURN  ;* Return CR.ENTRY
*
**************
EB.ACCOUNTING:
**************
*
    V = TT.TE.AUDIT.DATE.TIME
    CALL EB.ACCOUNTING("AC","SAO",Y.COMMON.ARRAY,'')

    Y.STMT.NO.NEW = R.NEW(TT.TE.STMT.NO)

    R.NEW(TT.TE.STMT.NO)       = Y.STMT.NO
    R.NEW(TT.TE.STMT.NO)<1,-1> = ID.COMPANY
    R.NEW(TT.TE.STMT.NO)<1,-1> = Y.STMT.NO.NEW

RETURN  ;* Return EB.ACCOUNTING
*
***************
GET.OTHER.INFO:
***************
*
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    IF R.ACCOUNT THEN
        Y.CUST.ID       = R.ACCOUNT<AC.CUSTOMER>
        Y.ACCT.OFFICER  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.ACCT.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    END

    Y.SUB.DIV.CODE  = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
    Y.EXCHANGE.RATE = R.NEW(TT.TE.RATE.1)
*
RETURN  ;*Return GET.OTHER.INFO
*
******
INIT:
******
*
    Y.ACCT.FLAG = @FALSE

    PROCESS.GOHEAD = @TRUE

    LOC.REF.APPLICATION = "TELLER" : @FM : "FT.COMMISSION.TYPE"
    LOC.REF.FIELDS      = "L.TT.TAX.CODE" : @VM : "L.TT.WV.TAX" : @VM : "L.TT.TAX.AMT" : @VM : "L.NCF.NUMBER" : @VM : "L.FT.NOSTRO.ACC"
    LOC.REF.FIELDS     := @FM : "L.WAIVE.CATEG"
    LREF.POS            = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
    POS.L.TT.TAX.CODE = LREF.POS<1,1>
    POS.L.TT.WV.TAX   = LREF.POS<1,2>
    POS.L.TT.TAX.AMT  = LREF.POS<1,3>
    POS.L.NCF.NUMBER  = LREF.POS<1,4>
    WPOSCN            = LREF.POS<1,5>
*
    POS.L.WAIVE.CATEG = LREF.POS<2,1>
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
        Y.TXN.CCY    = R.NEW(TT.TE.CURRENCY.1)
        Y.DR.ACCT.NO = R.NEW(TT.TE.ACCOUNT.1)<1,1>
    END ELSE
        Y.TXN.CCY    = R.NEW(TT.TE.CURRENCY.2)
        Y.DR.ACCT.NO = R.NEW(TT.TE.ACCOUNT.2)
    END

    Y.STMT.NO    = R.NEW(TT.TE.STMT.NO)
*
    Y.WV.TAX.CODE   = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.TAX.CODE>
    Y.WV.TAX.YES.NO = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.WV.TAX>
    Y.WV.TAX.AMT    = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.TAX.AMT>
    Y.WV.NCF.NUMBER = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.NCF.NUMBER>
    Y.ACCT.NOS      = R.NEW(TT.TE.LOCAL.REF)<1,WPOSCN>
*
    CHANGE @SM TO @FM IN Y.WV.TAX.CODE
    CHANGE @SM TO @FM IN Y.WV.TAX.YES.NO
    CHANGE @SM TO @FM IN Y.WV.TAX.AMT
    CHANGE @SM TO @FM IN Y.WV.NCF.NUMBER
*
    WAIVE.CAT  = ''
*
RETURN  ;* Return INIT
*
************
OPEN.FILES:
************
*
    FN.FTCT = 'F.FT.COMMISSION.TYPE'
    F.FTCT = ''
    CALL OPF(FN.FTCT,F.FTCT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
RETURN  ;* Return OPEN.FILES
*
*************
PRE.PROCESS:
*************
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOHEAD
        BEGIN CASE
            CASE LOOP.CNT EQ 1
*
                LOCATE "YES" IN Y.WV.TAX.YES.NO SETTING YES.NO.POS ELSE
                    PROCESS.GOHEAD = @FALSE
                END
*
            CASE LOOP.CNT EQ 2
*
                IF V$FUNCTION MATCHES "I"  OR V$FUNCTION EQ "A" AND R.NEW(TT.TE.RECORD.STATUS) MATCHES "INAU":@VM:"INAO" ELSE
                    PROCESS.GOHEAD = @FALSE
                END
*
                GOSUB GET.OTHER.INFO
*
            CASE LOOP.CNT EQ 3
*
                APAP.TAM.redoGetWaiveCateg(WAIVE.CAT);*R22 Manual Code conversion
*
        END CASE
*
        LOOP.CNT += 1
    REPEAT

RETURN  ;* Return PRE.PROCESS
*
END
