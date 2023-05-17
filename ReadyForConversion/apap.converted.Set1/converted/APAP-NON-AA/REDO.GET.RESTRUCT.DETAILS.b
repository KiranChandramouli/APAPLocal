SUBROUTINE REDO.GET.RESTRUCT.DETAILS(Y.ARRANGE.ID,LOAN.NUM,PORTFOLIO.TYPE,PRODUCT,LOAN.ORIGIN.AGENCY,PREV.LOAN.NUM,PRIME.NAME,RESTRUCTURE.DATE,CURR.DUE.DATE,TRANSACTION.USER,AUTHORISING.USER)
*-----------------------------------------------------------------------------
* DESCRIPTION : This is No-file routine for the Enquiry REDO.APAP.RESTRUCT.LOAN to
* display all restructured loans
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -NA-
* OUT    : Y.OUT.ARRAY
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.GET.RESTRUCT.DETAILS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE           DESCRIPTION
* 03-NOV-2010       RENUGADEVI B       ODR-2010-03-0127     INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_AA.ID.COMPONENT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB OPENFILES
    GOSUB GET.LOCAL.REF
    GOSUB MAIN.PROCESS
RETURN

**********
OPENFILES:
**********

    FN.CUSTOMER                 = 'F.CUSTOMER' ; F.CUSTOMER                  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.AA.ARR.CUSTOMER          = 'F.AA.ARR.CUSTOMER' ; F.AA.ARR.CUSTOMER           = ''
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
    FN.AA.ARR.ACCOUNT           = 'F.AA.ARR.ACCOUNT' ; F.AA.ARR.ACCOUNT            =  ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)
    FN.AA.ARRANGEMENT           = 'F.AA.ARRANGEMENT' ; F.AA.ARRANGEMENT            = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.AA.ACCOUNT.DETAILS       = 'F.AA.ACCOUNT.DETAILS' ; F.AA.ACCOUNT.DETAILS        = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.AA.ARR.TERM.AMOUNT       = 'F.AA.ARR.TERM.AMOUNT' ; F.AA.ARR.TERM.AMOUNT        = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    FN.AA.ARR.PAYMENT.SCHEDULE  = 'F.AA.ARR.PAYMENT.SCHEDULE' ; F.AA.ARR.PAYMENT.SCHEDULE   = ''
    CALL OPF(FN.AA.ARR.PAYMENT.SCHEDULE,F.AA.ARR.PAYMENT.SCHEDULE)
    FN.AA.ARR.OVERDUE           = 'F.AA.ARR.OVERDUE' ; F.AA.ARR.OVERDUE            = ''
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)
    FN.AA.ARRANGEMENT.ACTIVITY  = 'F.AA.ARRANGEMENT.ACTIVITY' ; F.AA.ARRANGEMENT.ACTIVITY   = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    FN.AA.ACTIVITY.HISTORY      = 'F.AA.ACTIVITY.HISTORY' ; F.AA.ACTIVITY.HISTORY       = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    FN.AA.INTEREST.ACCRUALS     = 'F.AA.INTEREST.ACCRUALS'; F.AA.INTEREST.ACCRUALS      = ''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    FN.AA.BILL.DETAILS          = 'F.AA.BILL.DETAILS'  ; F.AA.BILL.DETAILS              = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    PRIME.NAME = ''
RETURN

**************
GET.LOCAL.REF:
**************
    APPL.ARRAY           = 'AA.ARR.OVERDUE'
    FLD.ARRAY            = 'L.LOAN.STATUS':@VM:'L.STATUS.CHG.DT'
    FLD.POS              = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.LOAN.STATUS.POS  = FLD.POS<1,1>
    L.STATUS.CHG.DT.POS  = FLD.POS<1,2>
RETURN

*************
MAIN.PROCESS:
*************

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGE.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARRNG.ERR)
    LOAN.NUM           = Y.ARRANGE.ID
    PORTFOLIO.TYPE     = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    PRODUCT            = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.ARR.CUST         = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.AA.CURR          = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    LOAN.ORIGIN.AGENCY = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,LOAN.NUM,R.AA.ACCOUNT,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    CURR.DUE.DATE      = R.AA.ACCOUNT<AA.AD.MATURITY.DATE>
    GOSUB GET.ARR.ACC.DETAILS
    GOSUB GET.ARR.CUS.DETAILS
    GOSUB GET.AA.ARR.OVERDUE
    GOSUB GET.AA.ARR.ACT
RETURN

********************
GET.ARR.ACC.DETAILS:
********************
    ArrangementID      = Y.ARRANGE.ID ; idPropertyClass = 'ACCOUNT'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION          = RAISE(returnConditions)
    PREV.LOAN.NUM      = R.CONDITION<AA.AC.ALT.ID>
RETURN

********************
GET.ARR.CUS.DETAILS:
********************
    ArrangementID   = Y.ARRANGE.ID ; idPropertyClass = 'CUSTOMER'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION     = RAISE(returnConditions)
    Y.PRIM.CUST     = R.CONDITION<AA.CUS.PRIMARY.OWNER>
    Y.OWNER.CUST    = R.CONDITION<AA.CUS.OWNER>
    GOSUB SAMPLE.CUS.DETAILS
RETURN

*******************
SAMPLE.CUS.DETAILS:
*******************
    Y.PRIM = ''
    LOOP
        REMOVE Y.CUS.ID FROM Y.OWNER.CUST SETTING CUS1.POS
    WHILE Y.CUS.ID:CUS1.POS
        IF Y.PRIM.CUST EQ Y.CUS.ID THEN
        END ELSE
            Y.PRIM<-1> = Y.CUS.ID
        END
    REPEAT
    Y.PRIM.CUST<-1> = Y.PRIM
    LOOP
        REMOVE Y.PRIM.ID FROM Y.PRIM.CUST SETTING CUS2.POS
    WHILE Y.PRIM.ID:CUS2.POS
        CALL F.READ(FN.CUSTOMER,Y.PRIM.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        PRIME.NAME<-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
    REPEAT
    CHANGE @FM TO @VM IN PRIME.NAME
RETURN

*******************
GET.AA.ARR.OVERDUE:
*******************
    ArrangementID        = Y.ARRANGE.ID ; idPropertyClass = 'OVERDUE'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
    R.CONDITION          = RAISE(returnConditions)
    Y.LOAN.STATUS.1      = R.CONDITION<AA.OD.LOCAL.REF,L.LOAN.STATUS.POS>
    IF  Y.LOAN.STATUS.1 EQ 'Restructured' THEN
        RESTRUCTURE.DATE = R.CONDITION<AA.OD.LOCAL.REF,L.STATUS.CHG.DT.POS>
    END
RETURN
***************
GET.AA.ARR.ACT:
***************

    IN.PROPERTY.CLASS  = 'OVERDUE' ; OUT.PROPERTY       = '' ; R.OUT.AA.RECORD    = '' ; OUT.ERR            = ''
    CALL REDO.GET.PROPERTY.NAME(Y.ARRANGE.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    Y.FLAG = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.ARRANGE.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,Y.ERR.ACT.HIS)
    IF R.AA.ACTIVITY.HISTORY THEN
        ORIG.ACT       = "LENDING-UPDATE-":OUT.PROPERTY
        Y.ACT          = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        ACT.COUNT.VM   = DCOUNT(Y.ACT,@VM)
        CNT            = 1
        LOOP
        WHILE CNT LE ACT.COUNT.VM
            Y.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,CNT>
            LOCATE ORIG.ACT IN Y.ACTIVITY<1,1,1> SETTING Y.POS THEN
                Y.ARR.ACT.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,CNT,Y.POS>
                GOSUB GET.ACTIVITY.DETAILS
            END
            CNT += 1
        REPEAT
    END
RETURN
*********************
GET.ACTIVITY.DETAILS:
*********************
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ARR.ACT.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ACT.ERR)
    IF Y.FLAG NE '1' THEN
        TXN.INPUT          = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INPUTTER>
        TRANSACTION.USER   = FIELD(TXN.INPUT,'_',2,1)
        TXN.AUTHOR         = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.AUTHORISER>
        AUTHORISING.USER   = FIELD(TXN.AUTHOR,'_',2,1)
        Y.FLAG =1
    END
RETURN
*-----------------------------------------------------------------------------------------------
END
