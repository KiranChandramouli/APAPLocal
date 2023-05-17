*-----------------------------------------------------------------------------
* <Rating>-78</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.VI.VOUCHER.APPLY.CHG


******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Balagurunathan
*  Program   Name    :REDO.VI.APPROVE.CR.VOUCHER
***********************************************************************************
*Description: This routine is to settle the transaction when it is approved manually
*             This is a version routine attached to VERSION REDO.VISA.SETTLEMENT.05TO37,APPROVE as
*             input routine
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*23.05.2012   Balagurunathan  ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.USER
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.MERCHANT.CATEG
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.STLMT.PARAM




    GOSUB INIT
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
    RETURN

*****
INIT:
******

    TRANSACTION.ID = ''
    PROCESS = ''
    GTSMODE  =''
    OFSRECORD  = ''
    OFS.MSG.ID = ''
    OFS.ERR = ''
    OFS.STRING = ''
    OFS.ERR = ''

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  =''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.MERCHANT.CATEG='F.REDO.MERCHANT.CATEG'
    F.REDO.MERCHANT.CATEG=''
    CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    FN.REDO.VISA.STLMT.PARAM='F.REDO.VISA.STLMT.PARAM'

    FN.FT.TXN.TYPE.CONDITION='F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION=''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,PARAMETER.ID,R.REDO.APAP.H.PARAMETER,PARAMETER.ERROR)
    R.FUNDS.TRANSFER=''

    FN.REDO.VISA.STLMT.05TO37='F.REDO.VISA.STLMT.05TO37'
    F.REDO.VISA.STLMT.05TO37=''
    CALL OPF(FN.REDO.VISA.STLMT.05TO37,F.REDO.VISA.STLMT.05TO37)

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE=''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    RETURN

*-----------------------------------------------------------------------
GET.LOCAL.REF:
*-----------------------------------------------------------------------
    LOC.REF.APPLICATION="FUNDS.TRANSFER":FM:"ACCOUNT"
    LOC.REF.FIELDS='AT.UNIQUE.ID':VM:'POS.COND':VM:'BIN.NO':VM:'AT.AUTH.CODE':VM:'ATM.TERM.ID':VM:'L.STLMT.ID':VM:'L.STLMT.APPL':FM:'L.AC.AV.BAL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.AT.UNIQUE.ID=LOC.REF.POS<1,1>
    POS.POS.COND=LOC.REF.POS<1,2>
    POS.BIN.NO=LOC.REF.POS<1,3>
    POS.AT.AUTH.CODE=LOC.REF.POS<1,4>
    POS.ATM.TERM.ID=LOC.REF.POS<1,5>
    POS.STLMT.ID=LOC.REF.POS<1,6>
    POS.STLMT.APPL=LOC.REF.POS<1,7>
    POS.L.AC.AV.BAL=LOC.REF.POS<2,1>

    RETURN
**********
PROCESS:
**********

    ATM.REV.ID=R.NEW(FT.LOCAL.REF)<1,POS.AT.UNIQUE.ID>

    CALL F.READ(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)

    Y.ACCT.NO=R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>

    Y.FTTC.ID=R.ATM.REVERSAL<AT.REV.FTTC.ID>

    CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.FTTC.ID,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,Y.ERR)

    GOSUB GET.ACCT.DETAILS

    Y.COMM=R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    Y.CHG=R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>
    Y.TXN.CR=R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.CR>
    Y.TXN.DR=R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.DR>
    Y.CCY.CODE= R.ATM.REVERSAL<AT.REV.CURRENCY.CODE>
    Y.TXN.AMT=R.NEW(VISA.SETTLE.DEST.AMT)

    STLMT.ID=R.NEW(FT.LOCAL.REF)<1,POS.STLMT.ID>
    CALL F.READ(FN.REDO.VISA.STLMT.05TO37,STLMT.ID,R.REDO.VISA.STLMT.05TO37,F.REDO.VISA.STLMT.05TO37,STLMT.ERRR)
    Y.TXN.AMT=R.REDO.VISA.STLMT.05TO37<VISA.SETTLE.DEST.AMT>
    TC.CODE=R.REDO.VISA.STLMT.05TO37<VISA.SETTLE.TRANSACTION.CODE>

    R.REDO.VISA.STLMT.05TO37<VISA.SETTLE.T24.TRAN.REF>=ID.NEW
    CALL F.WRITE(FN.REDO.VISA.STLMT.05TO37,STLMT.ID,R.REDO.VISA.STLMT.05TO37)

    IF TC.CODE EQ '06' OR TC.CODE EQ 26 THEN

        RETURN
    END

    IF R.FT.TXN.TYPE.CONDITION THEN
        Y.FT.TXN.CHRG=R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>

        Y.FT.TXN.CHRG.CNT=DCOUNT(R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>,VM)
        T.DATAA=''
        LOOP
            REMOVE Y.FT.CHRG FROM Y.FT.TXN.CHRG SETTING POS.CHRG

        WHILE Y.FT.CHRG:POS.CHRG
            T.DATAA=''
*FT5.CURRENCY TO 7,            FT5.FLAT.AMT
            T.DATAA<1,-1>=Y.FT.CHRG
            T.DATAA<2,-1>='CHG'
            CALL F.READ(FN.FT.CHARGE.TYPE,Y.FT.CHRG,R.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE,CHG.ERR)
            VAR.INW.CLEAR.CATEG=R.FT.CHARGE.TYPE<FT5.CATEGORY.ACCOUNT>
            GOSUB  CALC.CHG
        REPEAT

        Y.FT.COMM=R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
        Y.FT.COMM.CNT=DCOUNT(R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>,VM)

        LOOP
            REMOVE Y.FT.COM FROM Y.FT.TXN.CHRG SETTING POS.CHRG

        WHILE Y.FT.CHRG:POS.CHRG
            T.DATAA=''
*FT5.CURRENCY TO 7,            FT5.FLAT.AMT
            T.DATAA<1,-1>=Y.FT.COM
            T.DATAA<2,-1>='COM'
            CALL F.READ(FN.FT.COMMISSION.TYPE,Y.FT.COM,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,COMM.ERR)
            VAR.INW.CLEAR.CATEG=R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
            GOSUB  CALC.CHG
        REPEAT
    END

    RETURN

CALC.CHG:

    IF Y.CCY.CODE NE '214' THEN


        DEAL.CURRENCY='USD'
        DEAL.AMOUNT=  Y.TXN.AMT

        CCY.MARKET=R.FT.TXN.TYPE.CONDITION<FT6.DEFAULT.DEAL.MKT>

        CALL CALCULATE.CHARGE(CUSTOMER, DEAL.AMOUNT, DEAL.CURRENCY, CCY.MARKET,CROSS.RATE, CROSS.CURRENCY, DRAWDOWN.CCY, T.DATAA, CUST.COND, CHG.AMT.TOT, TOT.CHARGE.FCCY)


    END ELSE


        DEAL.CURRENCY='DOP'
        DEAL.AMOUNT=  Y.TXN.AMT


        CALL CALCULATE.CHARGE(CUSTOMER, DEAL.AMOUNT, DEAL.CURRENCY, CCY.MARKET,CROSS.RATE, CROSS.CURRENCY, DRAWDOWN.CCY, T.DATAA, CUST.COND,CHG.AMT.TOT , TOT.CHARGE.FCCY)

    END

    STMT.CRF.TYPE=''
    CAT.CRF.TYPE=''
    STMT.CHG.AMT=0
    CAT.CHG.AMT=0


    BEGIN CASE


    CASE TC.CODE EQ 26
        STMT.CRF.TYPE='DEBIT'
        CAT.CRF.TYPE='CREDIT'
        CAT.CHG.AMT=CHG.AMT.TOT
        STMT.CHG.AMT=CHG.AMT.TOT * -1


        VAR.CAT.CR.CODE=Y.TXN.CR
        VAR.STE.CR.CODE=Y.TXN.DR

    CASE TC.CODE EQ '06' OR TC.CODE EQ '25' OR TC.CODE EQ '27'
        STMT.CRF.TYPE='CREDIT'
        CAT.CRF.TYPE='DEBIT'
        CAT.CHG.AMT=CHG.AMT.TOT * -1
        STMT.CHG.AMT=CHG.AMT.TOT
        VAR.CAT.CR.CODE =Y.TXN.DR
        VAR.STE.CR.CODE =Y.TXN.CR
    END CASE


    GOSUB RAISE.ENTRY

    RETURN

RAISE.ENTRY:

    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>
    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    R.STMT.ARR<AC.STE.AMOUNT.LCY> = STMT.CHG.AMT

    R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.STE.CR.CODE

    R.STMT.ARR<AC.STE.CUSTOMER.ID> =Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = Y.PRODUCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY> =Y.ACC.CUR
    R.STMT.ARR<AC.STE.POSITION.TYPE>=Y.POS.TYPE
    R.STMT.ARR<AC.STE.OUR.REFERENCE>=ID.NEW       ;* need to be created
    R.STMT.ARR<AC.STE.EXPOSURE.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>="1"
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>=Y.DEPT.CODE
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>= ''        ;*need to be created
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "FT" ;* PACS00596145
    R.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
* R.STMT.ARR<AC.STE.CRF.TYPE>= STMT.CRF.TYPE

    MULTI.STMT=''
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)

    GOSUB RAISE.CATG.ENTRIES
    MULTI.STMT<-1> =LOWER(R.CATEG.ENT)
    Y.STMT.NO = R.NEW(FT.STMT.NOS)
    CALL EB.ACCOUNTING("FT","SAO",MULTI.STMT,'')




    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)
    R.NEW(FT.STMT.NOS) = Y.STMT.NO
    R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
    R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW

    RETURN


*----------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*----------------------------------------------------------------------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = CAT.CHG.AMT

    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = VAR.CAT.CR.CODE

    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>= ''
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = VAR.INW.CLEAR.CATEG
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = ''
    R.CATEG.ENT<AC.CAT.VALUE.DATE>= TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY> = 'DOP'
    R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> =''
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = ID.NEW
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "FT"          ;* PACS00596145
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.NARRATIVE> = ''

*   R.CATEG.ENT<AC.CAT.CRF.TYPE> = CAT.CRF.TYPE  ; * PACS00596145


    RETURN


GET.ACCT.DETAILS:

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)


    Y.CUSTOMER=R.ACCOUNT<AC.CUSTOMER>
    Y.ACCT.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.PRODUCT.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.ACC.CUR = R.ACCOUNT<AC.CURRENCY>
    Y.POS.TYPE = R.ACCOUNT<AC.POSITION.TYPE>
    Y.CCY.MARKET = R.ACCOUNT<AC.CURRENCY.MARKET>
    Y.DEPT.CODE  = R.ACCOUNT<AC.DEPT.CODE>

    RETURN

END
