* @ValidationCode : MjotMTQ3NjA5NjY5MzpDcDEyNTI6MTY4MjQxMjMzOTMwOTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.FT.WV.COMTAX.VAL
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : J.COSTA C
*
*----------------------------------------------------------
*
* DESCRIPTION     : INPUT routine to be used in FT versions
*                   Accounting of each COMM/TAX value in a separate debit
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO                       REFERENCE       DESCRIPTION
*  13-AUG-2018      GOPALA KRISHNAN R    PACS00692300    Changed as INPUT routine.
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,F.READ TO CACHE.READ
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.BENEFICIARY
*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
*
    IF PROCESS.GOHEAD THEN
        GOSUB PROCESS
    END
*
RETURN          ;* END
*
* ======
PROCESS:
* ======
*

    GOSUB GET.TRANSACTION.INFO

    Y.SUB.DIV.CODE  = R.COMPANY(EB.COM.SUB.DIVISION.CODE)

    GOSUB GET.ACCOUNT.INFO

    R.NEW(FT.CHARGE.CODE)     = "WAIVE"
    R.NEW(FT.COMMISSION.CODE) = "WAIVE"

* Taxes



    Y.COMMON.ARRAY = ""
    Y.TAX.CODE.CNT = DCOUNT(Y.WV.TAX.CODE,@FM)
    Y.TAX.CTR = 1

    LOOP
    WHILE Y.TAX.CTR LE Y.TAX.CODE.CNT

        Y.TAX.AMT         = Y.WV.TAX.AMT<Y.TAX.CTR>
        Y.FTCT.ID         = Y.WV.TAX.CODE<Y.TAX.CTR>

        GOSUB CALC.TAX.AMT
        GOSUB GET.FTCT.DTLS

        IF Y.WV.TAX.YES.NO<Y.TAX.CTR> EQ "YES" AND Y.WAIVE.CATEG THEN
            Y.PL.CATEG    = Y.WAIVE.CATEG
            NARRATIVE     = 'APAP FT TAX - WAIVED'
            W.TAX.ACCOUNT = Y.WAIVE.CATEG
            Y.TAX.AMT.LCY = Y.TAX.AMT.LCY * -1
            Y.TAX.AMT.FCY = Y.TAX.AMT.FCY * -1
            GOSUB POPULATE.CATEG.ENTRY
            NARRATIVE = 'TAX ENTRY - WAIVED'
            W.TAX.ACCOUNT = Y.TAX.ACCOUNT
            GOSUB POPULATE.STMT.ENTRY
        END ELSE
            Y.PL.CATEG    = ''
            NARRATIVE     = 'APAP FT TAX'
            W.TAX.ACCOUNT = Y.DR.ACCT.NO
            GOSUB POPULATE.STMT.ENTRY
            W.TAX.ACCOUNT = Y.TAX.ACCOUNT
            NARRATIVE     = 'TAX ENTRY'
            GOSUB POPULATE.CATEG.ENTRY
        END

        Y.TAX.CTR += 1

    REPEAT
*
* Commissions
*
    Y.COM.CODE.CNT = DCOUNT(Y.WV.COM.CODE,@FM)
    Y.COM.CTR = 1
    LOOP
    WHILE Y.COM.CTR LE Y.COM.CODE.CNT

        Y.COM.AMT         = Y.WV.COM.AMT<Y.COM.CTR>
        Y.TAX.AMT         = Y.WV.COM.AMT<Y.COM.CTR>
        Y.FTCT.ID         = Y.WV.COM.CODE<Y.COM.CTR>

        GOSUB CALC.COM.AMT
        GOSUB GET.FTCT.DTLS

*   IF Y.WV.COM.YES.NO<Y.COM.CTR> EQ "YES" AND Y.WAIVE.CATEG THEN
*       Y.PL.CATEG    = Y.WAIVE.CATEG
*       NARRATIVE     = 'APAP FT COMM - WAIVED'
*       W.TAX.ACCOUNT = Y.TAX.ACCOUNT
*       GOSUB POPULATE.CATEG.ENTRY
*       NARRATIVE     = 'COMM ENTRY - WAIVED'
*       W.TAX.ACCOUNT = Y.WAIVE.CATEG
*       GOSUB POPULATE.STMT.ENTRY
*   END ELSE
        IF Y.WV.COM.YES.NO<Y.COM.CTR> EQ "NO" THEN
            Y.PL.CATEG    = ''
            NARRATIVE     = 'APAP FT COMM'
            W.TAX.ACCOUNT = Y.DR.ACCT.NO
            GOSUB POPULATE.STMT.ENTRY
            NARRATIVE     = 'COMM ENTRY'
            W.TAX.ACCOUNT = Y.TAX.ACCOUNT
            GOSUB POPULATE.CATEG.ENTRY
        END
*  END

        Y.COM.CTR += 1

    REPEAT
*
    IF Y.COMMON.ARRAY THEN
        GOSUB EB.ACCOUNTING
    END
*
RETURN          ;* Return PROCESS
*
* ===================
GET.TRANSACTION.INFO:
* ===================
*
    Y.TXN.CCY       = R.NEW(FT.DEBIT.CURRENCY)
    Y.DR.ACCT.NO    = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CR.ACCT.NO    = R.NEW(FT.CREDIT.ACCT.NO)
    Y.DR.VALUE.DATE = R.NEW(FT.DEBIT.VALUE.DATE)
    Y.CR.VALUE.DATE = R.NEW(FT.CREDIT.VALUE.DATE)
    Y.COMM.CODE     = R.NEW(FT.COMMISSION.CODE)
    Y.STMT.NO       = R.NEW(FT.STMT.NOS)
    Y.EXCHANGE.RATE = R.NEW(FT.IN.EXCH.RATE)

    BEN.ID=R.NEW(FT.BENEFICIARY.ID)
    CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BEN, BEN.ERR)  ;*R22 AUTO CODE CONVERSION
    IF NOT(BEN.ERR) THEN
        BEN.OTH.BANK.FLAG=R.BEN<ARC.BEN.LOCAL.REF,BEN.OWN.OTH.BANK.POS>
        IF BEN.OTH.BANK.FLAG EQ 'YES' THEN
            R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.CODE> = ''
            R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.TAX>     = 'YES'
            R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT >  = ''
        END
    END

    Y.TRANS.AMT     = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TRANS.AMT>))
    Y.FT.COMM.CODE  = R.NEW(FT.LOCAL.REF)<1,Y.L.FT.COMM.POS>
    Y.WV.TAX.CODE   = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.CODE>
    Y.WV.TAX.YES.NO = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.TAX>
    Y.WV.TAX.AMT    = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT>

    CHANGE @SM TO @FM IN Y.WV.TAX.CODE
    CHANGE @SM TO @FM IN Y.WV.TAX.YES.NO
    CHANGE @SM TO @FM IN Y.WV.TAX.AMT

    Y.WV.COM.CODE   = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COM.CODE>
    Y.WV.COM.YES.NO = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.COM>
    Y.WV.COM.AMT    = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COM.AMT>

    CHANGE @SM TO @FM IN Y.WV.COM.CODE
    CHANGE @SM TO @FM IN Y.WV.COM.YES.NO
    CHANGE @SM TO @FM IN Y.WV.COM.AMT

    IF R.NEW(FT.DEBIT.AMOUNT) THEN
        WTRAN.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
    END ELSE
        WTRAN.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
    END
*
RETURN
*
* ===============
GET.ACCOUNT.INFO:
* ===============
*
    IF Y.FT.COMM.CODE EQ "CREDIT LESS CHARGES" THEN
        Y.DR.ACCT.NO = Y.CR.ACCT.NO
    END
*
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    IF R.ACCOUNT THEN
        Y.CUST.ID       = R.ACCOUNT<AC.CUSTOMER>
        Y.ACCT.OFFICER  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.ACCT.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    END
*
RETURN          ;*Return GET.OTHER.INFO
*
* ===========
CALC.TAX.AMT:
* ===========

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
RETURN          ;* Return CALC.TAX.AMT
*
* ===========
CALC.COM.AMT:
* ===========
*
    Y.TAX.AMT.FCY = ''
    Y.TAX.AMT.LCY = ''

    IF Y.TXN.CCY EQ LCCY THEN
        Y.TAX.AMT.LCY = Y.COM.AMT
        Y.TAX.AMT.FCY = ''
    END

    IF Y.TXN.CCY NE LCCY THEN
        Y.TAX.AMT.FCY = Y.COM.AMT
        Y.TAX.AMT.LCY = Y.COM.AMT * Y.EXCHANGE.RATE
    END
*
RETURN          ;* Return CALC.COM.AMT
*
* ============
GET.FTCT.DTLS:
* ============
*
    R.FTCT         = ""
    Y.WAIVE.CATEG  = ""
*
    CALL CACHE.READ(FN.FTCT, Y.FTCT.ID, R.FTCT, FTCT.ERR)  ;*R22 AUTO CODE CONVERSION
    IF R.FTCT THEN
        Y.TR.CODE.DR   = R.FTCT<FT4.TXN.CODE.CR>
        Y.TR.CODE.CR   = R.FTCT<FT4.TXN.CODE.DR>
        Y.TAX.ACCOUNT  = R.FTCT<FT4.CATEGORY.ACCOUNT>
        Y.WAIVE.CATEG  = R.FTCT<FT4.LOCAL.REF,POS.L.WAIVE.CATEG>
    END
*
RETURN          ;* Return GET.FTCT.DTLS
*
* ===================
POPULATE.CATEG.ENTRY:
* ===================
*

    R.CATEG.ENT                          = ''
*
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER>   = ''
    R.CATEG.ENT<AC.CAT.PL.CATEGORY>      = ""
    R.CATEG.ENT<AC.CAT.CRF.TYPE>         = "DEBIT"
    R.CATEG.ENT<AC.CAT.THEIR.REFERENCE>  = ''
    R.CATEG.ENT<AC.CAT.POSITION.TYPE>    = 'TR'
    R.CATEG.ENT<AC.CAT.SYSTEM.ID>        = "AC"
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET>  = "1"
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>     = ID.COMPANY
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE>  = ID.NEW
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE>    = Y.DR.ACCT.NO
    R.CATEG.ENT<AC.CAT.BOOKING.DATE>     = TODAY
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
*
    R.CATEG.ENT<AC.CAT.NARRATIVE>        = NARRATIVE
    R.CATEG.ENT<AC.CAT.VALUE.DATE>       = Y.DR.VALUE.DATE
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY>       = Y.TAX.AMT.LCY
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = Y.TR.CODE.DR
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>      = Y.CUST.ID
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER>  = Y.ACCT.OFFICER
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = Y.ACCT.CATEGORY
    R.CATEG.ENT<AC.CAT.CURRENCY>         = Y.TXN.CCY
*
    IF Y.TXN.CCY EQ LCCY THEN
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY>    = ''
        R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> = ''
    END ELSE
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY>    = Y.TAX.AMT.FCY
        R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> = Y.EXCHANGE.RATE
    END
*
    IF Y.PL.CATEG THEN
        R.CATEG.ENT<AC.CAT.PL.CATEGORY>      = Y.PL.CATEG
    END ELSE
        IF LEN(W.TAX.ACCOUNT) EQ 5 THEN
            R.CATEG.ENT<AC.CAT.PL.CATEGORY>    = W.TAX.ACCOUNT
        END ELSE
            R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = W.TAX.ACCOUNT
        END
    END
*
    Y.COMMON.ARRAY<-1> = LOWER(R.CATEG.ENT)
*
RETURN          ;* Return POPULATE.CATEG.ENTRY
*
* ==================
POPULATE.STMT.ENTRY:
* ==================
*
    R.STMT.ARR                           = ''
*
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>   = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>   = '1'
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>   = ID.NEW
    R.STMT.ARR<AC.STE.SYSTEM.ID>         = "AC"
    R.STMT.ARR<AC.STE.BOOKING.DATE>      = TODAY
    R.STMT.ARR<AC.STE.CRF.TYPE>          = "CREDIT"
    R.STMT.ARR<AC.STE.THEIR.REFERENCE>   = ''
    R.STMT.ARR<AC.STE.POSITION.TYPE>     = 'TR'
*
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER>    = W.TAX.ACCOUNT
    R.STMT.ARR<AC.STE.COMPANY.CODE>      = ID.COMPANY
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>  = Y.TR.CODE.CR
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER>   = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY>  = Y.ACCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE>        = Y.CR.VALUE.DATE
    R.STMT.ARR<AC.STE.CURRENCY>          = Y.TXN.CCY
*
    IF Y.CUST.ID THEN
        R.STMT.ARR<AC.STE.CUSTOMER.ID>  = Y.CUST.ID
    END
*
    IF Y.TXN.CCY EQ LCCY THEN
        R.STMT.ARR<AC.STE.AMOUNT.LCY>         = Y.TAX.AMT.LCY * '-1'
        R.STMT.ARR<AC.STE.EXCHANGE.RATE> = ''
        R.STMT.ARR<AC.STE.AMOUNT.FCY>    = ''
    END ELSE
        R.STMT.ARR<AC.STE.AMOUNT.FCY>         = Y.TAX.AMT.FCY * '-1'
        R.STMT.ARR<AC.STE.EXCHANGE.RATE> = Y.EXCHANGE.RATE
    END
*
    Y.COMMON.ARRAY<-1> = LOWER(R.STMT.ARR)
*
RETURN          ;* Return POPULATE.STMT.ENTRY
*
* ============
EB.ACCOUNTING:
* ============
*

    V = FT.AUDIT.DATE.TIME
    IF V$FUNCTION EQ 'I' THEN
        CALL EB.ACCOUNTING("AC","VAL",Y.COMMON.ARRAY,'')
    END

    IF V$FUNCTION EQ 'D' THEN
        CALL EB.ACCOUNTING("AC","DEL",'','')
    END
*    Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)

*    R.NEW(FT.STMT.NOS)       = Y.STMT.NO
*    R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
*    R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW

RETURN          ;* Return EB.ACCOUNTING
*
* ===
INIT:
* ===
*
    PROCESS.GOHEAD = 1

    LREF.APPLICATION = "FUNDS.TRANSFER" : @FM : "FT.COMMISSION.TYPE" : @FM : "BENEFICIARY"
    LOC.REF.FIELDS   = "L.TT.TAX.CODE" : @VM : "L.TT.WV.TAX" : @VM : "L.TT.TAX.AMT" : @VM
    LOC.REF.FIELDS  := "L.TT.COMM.CODE" : @VM : "L.TT.WV.COMM" : @VM : "L.TT.COMM.AMT" : @VM :
    LOC.REF.FIELDS  := "L.TT.TRANS.AMT" : @VM : "L.FT.COMM.CODE"
    LOC.REF.FIELDS  := @FM : "L.WAIVE.CATEG"
    LOC.REF.FIELDS  := @FM : "L.BEN.OWN.ACCT"
    LREF.POS         = ''

    CALL MULTI.GET.LOC.REF(LREF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
    POS.L.TT.TAX.CODE = LREF.POS<1,1>
    POS.L.TT.WV.TAX   = LREF.POS<1,2>
    POS.L.TT.TAX.AMT  = LREF.POS<1,3>
    POS.L.TT.COM.CODE = LREF.POS<1,4>
    POS.L.TT.WV.COM   = LREF.POS<1,5>
    POS.L.TT.COM.AMT  = LREF.POS<1,6>
    Y.L.TT.TRANS.AMT  = LREF.POS<1,7>
    Y.L.FT.COMM.POS   = LREF.POS<1,8>
*
    POS.L.WAIVE.CATEG = LREF.POS<2,1>
*
    BEN.OWN.OTH.BANK.POS = LREF.POS<3,1>
*

    Y.FTCT.ID         = ''
    Y.DR.VALUE.DATE   = ''
    Y.CR.VALUE.DATE   = ''
    Y.PL.CATEG        = ''
    Y.TXN.CCY         = ''
    Y.DR.ACCT.NO      = ''
    Y.ACCT.CATEGORY   = ''
    Y.CUST.ID         = ''
*
RETURN          ;* Return INIT
*
* =========
OPEN.FILES:
* =========

    FN.FTCT = 'F.FT.COMMISSION.TYPE'
    F.FTCT = ''
    CALL OPF(FN.FTCT,F.FTCT)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

RETURN          ;* Return OPEN.FILES

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 1
*
    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOHEAD
        BEGIN CASE
            CASE LOOP.CNT EQ 1

* IF V$FUNCTION MATCHES "I"  OR V$FUNCTION EQ "A" AND R.NEW(FT.RECORD.STATUS) MATCHES "INAU":VM:"INAO" ELSE
                IF OFS.VAL.ONLY THEN
                    PROCESS.GOHEAD = ""
                END

        END CASE
*
        LOOP.CNT += 1
    REPEAT

    IF RUNNING.UNDER.BATCH THEN
        PROCESS.GOHEAD = '1'
    END
RETURN          ;* Return CHECK.PRELIM.CONDITIONS

END
