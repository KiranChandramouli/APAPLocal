SUBROUTINE REDO.AUTH.UPD.DEP.AMT.SMB
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.AUTH.UPD.DEP.AMT
* ODR NO      : ODR-2009-10-0315
*----------------------------------------------------------------------
*DESCRIPTION: This auth routine will calculate if the payment type is FT then sum of all the payments
* in multi-value field L.AZ.AMOUNT and credit to the same amount to deposit account

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AZ.ACCOUNT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*09.12.2011  S SUDHARSANAN   PACS00146871      Initial Creation
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.DEFAULT
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.AZ.FUND.PARAM

    GOSUB INIT
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.AZ.FUND.PARAM = 'F.REDO.AZ.FUND.PARAM'
    Y.AZ.VALUE.DATE = R.NEW(AZ.VALUE.DATE)

RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="AZ.ACCOUNT":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.AZ.METHOD.PAY':@VM:'L.AZ.AMOUNT':@VM:'L.AZ.DEBIT.ACC':@VM:'L.EB.REVIEW':@VM:'L.EB.PROFITLOSS':@VM:'L.EB.OLD.RATE':@VM:'L.EB.TASA.POOL':@VM:'L.TYPE.INT.PAY':@VM:'ORIG.LCY.AMT':@FM:'L.EB.REVIEW':@VM:'L.EB.PROFITLOSS':@VM:'L.EB.OLD.RATE':@VM:'L.EB.TASA.POOL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.METHOD.PAY=LOC.REF.POS<1,1>
    POS.L.AZ.AMOUNT=LOC.REF.POS<1,2>
    POS.L.AZ.DEBIT.ACC=LOC.REF.POS<1,3>
    POS.AZ.EB.REVIEW = LOC.REF.POS<1,4>
    POS.AZ.EB.PROFITLOSS = LOC.REF.POS<1,5>
    POS.AZ.EB.OLD.RATE = LOC.REF.POS<1,6>
    POS.AZ.EB.TASA.POOL = LOC.REF.POS<1,7>
    POS.L.TYPE.INT.PAY = LOC.REF.POS<1,8>
    POS.ORIG.LCY.AMT = LOC.REF.POS<1,9>
    POS.AC.EB.REVIEW = LOC.REF.POS<2,1>
    POS.AC.EB.PROFITLOSS = LOC.REF.POS<2,2>
    POS.AC.EB.OLD.RATE = LOC.REF.POS<2,3>
    POS.AC.EB.TASA.POOL = LOC.REF.POS<2,4>
    FINAL.PART = ''
    VAR.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.AZ.FUND.PARAM,VAR.ID,R.FUND.PARAM,FUND.ERR)
    Y.GENERIC.USER  = R.FUND.PARAM<REDO.FUND.OFS.USER>
    VAR.CURRENCY = R.NEW(AZ.CURRENCY)
    CCY.PARAM = R.FUND.PARAM<REDO.FUND.CURRENCY>
    CHANGE @VM TO @FM IN CCY.PARAM
    LOCATE VAR.CURRENCY IN CCY.PARAM SETTING CCY.POS THEN
        VAR.TRANSACTION.CODE = R.FUND.PARAM<REDO.FUND.TRANSACTION.CODE,CCY.POS>
        VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACCT.NUMBER,CCY.POS>
    END

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    Y.CURR.NO = R.OLD(AZ.CURR.NO)
    Y.REPAY.ACCOUNT = R.NEW(AZ.REPAY.ACCOUNT)
    Y.L.AZ.DEBIT.ACC = ''
    Y.L.AZ.DEBIT.ACC = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.DEBIT.ACC>
    Y.L.AZ.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT>

    IF NOT(Y.CURR.NO) AND NOT(Y.REPAY.ACCOUNT) THEN
        Y.VAR = ''
        DEB.ACC.CNT = DCOUNT(Y.L.AZ.DEBIT.ACC,@SM) ; DEB.CNT = 1
        CHANGE @SM TO @FM IN Y.L.AZ.DEBIT.ACC
        CHANGE @SM TO @FM IN Y.L.AZ.AMOUNT
        GOSUB GET.DEB.DETAILS
        IF NOT(Y.VAR) AND DEB.ACC.CNT THEN
            GOSUB UPDATE.DEP.AMT
        END
    END
    GOSUB UPDATE.POOL.RATE
RETURN
*--------------------------------------------------------------------
GET.DEB.DETAILS:
*---------------------------------------------------------------------
    LOOP
    WHILE DEB.CNT LE DEB.ACC.CNT
        Y.VAL = Y.L.AZ.DEBIT.ACC<DEB.CNT>
        IF NOT(Y.VAL) THEN
            Y.VAR = 1
            DEB.CNT = DEB.ACC.CNT
        END ELSE
            Y.AMT<-1> = Y.L.AZ.AMOUNT<DEB.CNT>
            Y.DEB.ACC<-1> = Y.VAL
        END
        DEB.CNT += 1
    REPEAT
RETURN
*----------------------------------------------------------------------
UPDATE.DEP.AMT:
*----------------------------------------------------------------------
    DEB.CNT = 1 ; VAR.AMOUNT = ''
    Y.DEB.ACC.CNT = DCOUNT(Y.DEB.ACC,@FM)
    LOOP
    WHILE DEB.CNT LE Y.DEB.ACC.CNT
        Y.AMOUNT = Y.AMT<DEB.CNT>
        VAR.AMOUNT +=Y.AMOUNT
        VAR.DEB.ACC = Y.DEB.ACC<DEB.CNT>
        R.FT = '' ; R.ACC = ''
        CALL F.READ(FN.ACCOUNT,VAR.DEB.ACC,R.ACC,F.ACCOUNT,ACC.ERR)
        IF R.ACC THEN
            GOSUB CHECK.CURRENCY
            APP.NAME = 'FUNDS.TRANSFER'
            OFSFUNCT = 'I'
            PROCESS  = 'PROCESS'
            OFSVERSION = 'FUNDS.TRANSFER,OFS.PROCESS'
            VAR.GTSMODE = ''
            NO.OF.AUTH = '0'
            TRANSACTION.ID = ''
            OFSRECORD = ''

            OFS.MSG.ID =''
            OFS.SOURCE.ID = 'REDO.AZ.UPD'
            OFS.ERR = ''

            CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FT,OFSRECORD)
*****************PACS00205726-S**************
            GOSUB UPD.FIN.COMP
            OFS.GENERIC.USER = Y.GENERIC.USER
            CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.GENERIC.USER)
*****************PACS00205726-E**************
        END
        DEB.CNT += 1
    REPEAT
    GOSUB UPDATE.TT
RETURN

*----------------------------
CHECK.CURRENCY:
*----------------------------
    Y.CUR = R.ACC<AC.CURRENCY>
    R.FT<FT.DEBIT.ACCT.NO>    = VAR.DEB.ACC
    R.FT<FT.DEBIT.CURRENCY>   = Y.CUR
    R.FT<FT.DEBIT.AMOUNT>     = Y.AMT<DEB.CNT>
    R.FT<FT.CREDIT.ACCT.NO>   = VAR.ACCT.NUM
    R.FT<FT.DEBIT.VALUE.DATE> = Y.AZ.VALUE.DATE
    R.FT.<FT.CREDIT.VALUE.DATE> = Y.AZ.VALUE.DATE
RETURN
*--------------------------
UPDATE.TT:
*--------------------------
    IF VAR.AMOUNT THEN
        R.TELL = ''
        R.TELL<TT.TE.TRANSACTION.CODE> =  VAR.TRANSACTION.CODE
        R.TELL<TT.TE.ACCOUNT.1> = VAR.ACCT.NUM

        R.TELL<TT.TE.CURRENCY.1> = VAR.CURRENCY
        R.TELL<TT.TE.VALUE.DATE.1> = Y.AZ.VALUE.DATE
        IF VAR.CURRENCY EQ LCCY THEN
            R.TELL<TT.TE.AMOUNT.LOCAL.1> = VAR.AMOUNT
        END ELSE
            R.TELL<TT.TE.AMOUNT.FCY.1> = VAR.AMOUNT
        END
        R.TELL<TT.TE.VALUE.DATE.2> = Y.AZ.VALUE.DATE
        R.TELL<TT.TE.ACCOUNT.2> = ID.NEW

        APP.NAME = 'TELLER'
        OFSFUNCT = 'I'
        PROCESS  = 'PROCESS'
        OFSVERSION = 'TELLER,OFS.PROCESS'
        VAR.GTSMODE = ''
        NO.OF.AUTH = '0'
        TRANSACTION.ID = ''
        OFSRECORD = ''

        OFS.MSG.ID =''
        OFS.SOURCE.ID = 'REDO.AZ.UPD'
        OFS.ERR = ''

        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.TELL,OFSRECORD)
*****************PACS00205726-S**************
        GOSUB UPD.FIN.COMP
        OFS.GENERIC.USER = Y.GENERIC.USER
        CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.GENERIC.USER)
*****************PACS00205726-E**************
    END
RETURN
*--------------------------------------------------------------------------
UPDATE.POOL.RATE:
*---------------------------------------------------------------------------
    IF R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY> EQ 'Reinvested' THEN
        Y.INT.LIQ.ACCT = R.NEW(AZ.INTEREST.LIQU.ACCT)
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        R.ACCOUNT<AC.LOCAL.REF,POS.AC.EB.REVIEW> = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.EB.REVIEW>
        R.ACCOUNT<AC.LOCAL.REF,POS.AC.EB.PROFITLOSS> = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.EB.PROFITLOSS>
        R.ACCOUNT<AC.LOCAL.REF,POS.AC.EB.OLD.RATE> = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.EB.OLD.RATE>
        R.ACCOUNT<AC.LOCAL.REF,POS.AC.EB.TASA.POOL> = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.EB.TASA.POOL>
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.ACCOUNT)
    END
RETURN
*---------------------------------------------------------------------------
UPD.FIN.COMP:
*-----------------------------------------------------------------------------
    TOTAL.COMM.CNTR = DCOUNT(OFSRECORD,",")

    MODIFY.PART1 = FIELD(OFSRECORD,",",1,2)
    MODIFY.PART2 = FIELD(OFSRECORD,",",3,1)
    MODIFY.PART3 = FIELD(OFSRECORD,",",4,TOTAL.COMM.CNTR)

    TOT.MODIFY.CNT2 = DCOUNT(MODIFY.PART2,"/")

    FIRST.MOD.PART=FIELD(MODIFY.PART2,"/",1,2)
    SECOND.MOD.PART = FIELD(MODIFY.PART2,"/",3,1)
    SECOND.MOD.PART = R.COMPANY(EB.COM.FINANCIAL.COM)
    THIRD.MOD.PART=FIELD(MODIFY.PART2,"/",4,TOT.MODIFY.CNT2)
    UPD.FINAL.PART = FIRST.MOD.PART:"/":SECOND.MOD.PART:"/":THIRD.MOD.PART
    FINAL.PART = MODIFY.PART1:",":UPD.FINAL.PART:",":MODIFY.PART3

    OFSRECORD = FINAL.PART

RETURN
*-------------------------------------------------------------------------------
END
