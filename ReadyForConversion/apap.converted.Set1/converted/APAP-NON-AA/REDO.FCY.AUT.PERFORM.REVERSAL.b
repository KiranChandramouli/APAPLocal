SUBROUTINE REDO.FCY.AUT.PERFORM.REVERSAL
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.FCY.AUT.PERFORM.REVERSAL
*-------------------------------------------------------------------------
* Description: This routine is a Authorisation routine
*
*----------------------------------------------------------
* Linked with:  Enquiry REDO.RETURN.FCY.CHQ
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-12          ODR-2010-09-0251              Initial Creation
* 13-04-12          PACS00188869                  use universal clearing A/C instead RETURN A/C
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.COLLECT.PARAM
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.OUTWARD.RETURN
    $INSERT I_F.REDO.GAR.LOCK.ALE
    $INSERT I_F.REDO.INTRANSIT.LOCK

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

    FN.REDO.APAP.PARAM = 'F.REDO.COLLECT.PARAM'
    F.REDO.APAP.PARAM =''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    FN.REDO.CLEAR.PARM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.CLEAR.PARM,F.REDO.CLEAR.PARAM)

    FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
    F.REDO.OUTWARD.RETURN = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

    FN.REDO.GAR.LOCK.ALE='F.REDO.GAR.LOCK.ALE'
    F.REDO.GAR.LOCK.ALE=''
    CALL OPF(FN.REDO.GAR.LOCK.ALE,F.REDO.GAR.LOCK.ALE)

    FN.REDO.INTRANSIT.LOCK = 'F.REDO.INTRANSIT.LOCK'
    F.REDO.INTRANSIT.LOCK  = ''
    CALL OPF(FN.REDO.INTRANSIT.LOCK,F.REDO.INTRANSIT.LOCK)

    FN.ALE = 'F.AC.LOCKED.EVENTS'
    F.ALE  = ''
    CALL OPF(FN.ALE,F.ALE)

RETURN

PROCESS:

*Get the Count of Transaction Field
    LOC.APPLICATION = 'CUSTOMER':@FM:'ACCOUNT'
    LOC.FIELDS = 'L.CU.SEGMENTO':@FM:'L.AC.TRAN.AVAIL':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.AV.BAL'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)

    CUS.LOC.POS = LOC.POS<1,1>
    TRAN.LOC.POS = LOC.POS<2,1>
    NOTIFY.LOC.POS = LOC.POS<2,2>
    Y.AC.AV.BAL.POS = LOC.POS<2,3>

    VAR.TXN.REF = R.NEW(CLEAR.OUT.TFS.REFERENCE)
    VAL.REFERENCE = VAR.TXN.REF[1,3]
    R.NEW(CLEAR.OUT.NARRATIVE) = 'RETURNED'
    ACCT.ID = R.NEW(CLEAR.OUT.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT.CL,F.ACCOUNT,ACCT.ERR)
    CUS.ID = R.ACCOUNT.CL<AC.CUSTOMER>
    CCY.ID = R.ACCOUNT.CL<AC.CURRENCY>
    Y.AC.AVAIL.BALANCE  = R.ACCOUNT.CL<AC.LOCAL.REF,Y.AC.AV.BAL.POS>
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    VAR.SEG = R.CUSTOMER<EB.CUS.LOCAL.REF><1,CUS.LOC.POS>
    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)
    CALL CACHE.READ(FN.REDO.CLEAR.PARM,'SYSTEM',R.REDO.CLEAR.PARAM,CLEAR.ERR)
    IF R.REDO.CLEAR.PARAM THEN
        VAR.CUS.TYPES = R.REDO.CLEAR.PARAM<CLEAR.PARAM.CUSTOMER.TYPE>
    END
    LOCATE VAR.SEG IN VAR.CUS.TYPES<1,1> SETTING SEG.POS THEN
        VAR.CHG.TYPE = R.REDO.CLEAR.PARAM<CLEAR.PARAM.FT.REF.CHG,SEG.POS>
    END
    Y.CCY.LIST = R.REDO.APAP.PARAM<COLLECT.PARAM.CAT.ACH.CCY>
    Y.ACCT.LIST = R.REDO.APAP.PARAM<COLLECT.PARAM.CAT.ACH.ACCT>
    CHANGE @VM TO @FM IN Y.ACCT.LIST
    CHANGE @VM TO @FM IN Y.CCY.LIST

    Y.UNIV.CCY.LIST  = R.REDO.APAP.PARAM<COLLECT.PARAM.UNIV.CLEAR.CCY>
    Y.UNIV.ACCT.LIST = R.REDO.APAP.PARAM<COLLECT.PARAM.UNIV.CLEAR.ACCT>

* PACS00188869 - S
    LOCATE CCY.ID IN Y.CCY.LIST SETTING CCY.POS THEN
        Y.CCY.ACCT = Y.ACCT.LIST<1,CCY.POS>
    END
* PACS00188869 - E

****************
*Raising FT Entry

    VAR.PAY.DETAILS = ID.NEW
    R.NEW(CLEAR.OUT.CHQ.STATUS) = 'RETURNED'

    R.FT.RECORD<FT.DEBIT.ACCT.NO>     = R.NEW(CLEAR.OUT.ACCOUNT)
    R.FT.RECORD<FT.DEBIT.AMOUNT>      = R.NEW(CLEAR.OUT.AMOUNT)
    R.FT.RECORD<FT.DEBIT.CURRENCY>    = CCY.ID
    R.FT.RECORD<FT.CREDIT.ACCT.NO>    = Y.CCY.ACCT
    R.FT.RECORD<FT.CHEQUE.NUMBER>     = R.NEW(CLEAR.OUT.CHEQUE.NO)
    IF VAR.CHG.TYPE THEN
        R.FT.RECORD<FT.CHARGES.ACCT.NO>    = R.NEW(CLEAR.OUT.ACCOUNT)
        R.FT.RECORD<FT.COMMISSION.TYPE> = VAR.CHG.TYPE
    END
    R.FT.RECORD<FT.PAYMENT.DETAILS>   = ID.NEW

    Y.RS.OFS.FLAG = 'SUCCESS'

    IF NOT(Y.AC.AVAIL.BALANCE GE R.NEW(CLEAR.OUT.AMOUNT)) THEN
        Y.RS.OFS.FLAG = 'FAIL'
        R.NEW(CLEAR.OUT.RETURN.STATUS) = "INSUFFICIENT_BALANCE"
    END

    IF (R.ACCOUNT.CL<AC.POSTING.RESTRICT>) THEN
        Y.RS.OFS.FLAG = 'FAIL'
        R.NEW(CLEAR.OUT.RETURN.STATUS) = 'POSTING_RESTRICTION'
    END

    IF (R.ACCOUNT.CL<AC.LOCAL.REF, NOTIFY.LOC.POS>) THEN
        Y.RS.OFS.FLAG = 'FAIL'
        R.NEW(CLEAR.OUT.RETURN.STATUS) = 'NOTIFICATION'
    END

    IF Y.RS.OFS.FLAG EQ 'SUCCESS' THEN
        GOSUB CREATE.FT
        GOSUB CREATE.OFS
    END
    ELSE
        AMOUNT.VAL = R.NEW(CLEAR.OUT.AMOUNT)
        IF AMOUNT.VAL THEN
            VAR.CURRENCY = R.NEW(CLEAR.OUT.CURRENCY)
            REDO.OUTWARD.RETURN.ID = ID.NEW
            CALL REDO.APAP.INF.SUFF.ACCT.ENT(AMOUNT.VAL,VAR.CURRENCY,REDO.OUTWARD.RETURN.ID)
        END
    END

**********************
*------------------------------*
*PACS00192050 - Changes - start
*------------------------------*
    CALL F.READ(FN.REDO.INTRANSIT.LOCK,ACCT.ID,R.REDO.INTRANSIT.LOCK,F.REDO.INTRANSIT.LOCK,TRANSIT.LOCK.ERR)
    Y.ALE.LIST = R.REDO.INTRANSIT.LOCK
    Y.ALE.INIT = 1
    Y.CNT = DCOUNT(Y.ALE.LIST,@FM)
    Y.RETURN.AMT = R.NEW(CLEAR.OUT.AMOUNT)
    Y.STOP.FLAG = ''
    LOOP
        REMOVE Y.ALE.ID FROM Y.ALE.LIST SETTING Y.ALE.POS
    WHILE Y.ALE.INIT LE Y.CNT
        CALL F.READ(FN.ALE,Y.ALE.ID,R.ALE,F.ALE,ALE.ERR)
        IF R.ALE THEN
            Y.ALE.AMT  = R.ALE<AC.LCK.LOCKED.AMOUNT>
            Y.ALE.ACCT = R.ALE<AC.LCK.ACCOUNT.NUMBER>
            IF Y.RETURN.AMT EQ Y.ALE.AMT AND Y.ALE.ACCT EQ ACCT.ID AND NOT(Y.STOP.FLAG) THEN
                Y.STOP.FLAG = 1
                GOSUB REVERSE.ALE
                GOSUB CREATE.OFS
            END
        END
        Y.ALE.INIT += 1
    REPEAT

*PACS00192050 - End
*----------------------*
    Y.CUSTOMER=R.ACCOUNT.CL<AC.CUSTOMER>
    CALL F.READ(FN.REDO.GAR.LOCK.ALE,Y.CUSTOMER,R.REDO.GAR.LOCK.ALE,F.REDO.GAR.LOCK.ALE,ERR)
    Y.RGO.ID.LIST=R.REDO.GAR.LOCK.ALE<TT.ALE.OUT.CLEAR.ID>
    Y.CUSTOMER.LIST=R.ACCOUNT.CL<AC.JOINT.HOLDER>
    Y.CUSTOMER.TOT=DCOUNT(Y.CUSTOMER.LIST,@VM)
    Y.CUSTOMER.CNT=1
    LOOP
    WHILE Y.CUSTOMER.CNT LE Y.CUSTOMER.TOT
        Y.CUSTOMER=Y.CUSTOMER.LIST<Y.CUSTOMER.CNT>
        CALL F.READ(FN.REDO.GAR.LOCK.ALE,Y.CUSTOMER,R.REDO.GAR.LOCK.ALE,F.REDO.GAR.LOCK.ALE,ERR)
        IF R.REDO.GAR.LOCK.ALE THEN
            Y.RGO.ID.LIST<-1>=R.REDO.GAR.LOCK.ALE<TT.ALE.OUT.CLEAR.ID>
        END
        Y.CUSTOMER.CNT += 1
    REPEAT
    CHANGE @VM TO @FM IN Y.RGO.ID.LIST
*LOCATE ID.NEW IN Y.RGO.ID.LIST SETTING Y.CLEAR.OUT.POS ELSE
*PACS00055620 -s
*R.ACCOUNT.CL<AC.LOCAL.REF,TRAN.LOC.POS> = R.ACCOUNT.CL<AC.LOCAL.REF,TRAN.LOC.POS> - R.NEW(CLEAR.OUT.AMOUNT)
*END
    R.ACCOUNT.CL<AC.LOCAL.REF,NOTIFY.LOC.POS> = 'RETURNED.CHEQUE'
    CALL F.WRITE(FN.ACCOUNT,ACCT.ID,R.ACCOUNT.CL)
*PACS00055620 -E

RETURN

CREATE.FT:
    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,CH.RL.FCY'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSRECORD = ''
RETURN

*--------------------------------------
REVERSE.ALE:
    APP.NAME       = ''
    R.FT.RECORD    = ''
    APP.NAME       = 'AC.LOCKED.EVENTS'
    OFSFUNCT       = 'R'
    PROCESS        = 'PROCESS'
    OFSVERSION     = 'AC.LOCKED.EVENTS,REDO'
    GTSMODE        = ''
    NO.OF.AUTH     = '0'
    TRANSACTION.ID = Y.ALE.ID
    OFSRECORD = ''

RETURN
*--------------------------------------
CREATE.OFS:

    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.CHQ.ISSUE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FT.RECORD,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
END
