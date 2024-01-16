* @ValidationCode : MjotMjEwNjY4NjkzODpDcDEyNTI6MTcwMzY1ODQ2MDMwMTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 11:57:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.APAP.NOFILE.RESTRUCT.LOAN(Y.OUT.ARRAY)
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
* PROGRAM NAME : REDO.APAP.NOFILE.RESTRUCT.LOAN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE           DESCRIPTION
* 03-NOV-2010       RENUGADEVI B       ODR-2010-03-0127     INITIAL CREATION
* 27-SEP-2012       MARIMUTHU S        PACS00218262
* 23-05-2023     Conversion Tool        R22 Auto Conversion - FM TO @FM AND VM TO @VM AND ++ TO + =1
* 23-05-2023      ANIL KUMAR B          R22 Manual Conversion - AA.CUS.OWNER changed to AA.CUS.CUSTOMER and AA.CUS.PRIMARY.OWNER changed to AA.CUS.CUSTOMER.
* 26-12-2023       VIGNESHWARI S            R22 MANUAL CONVERSTION       call rtn modified,AA.FRAMEWORK IS CHANGED
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
*    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
  *  $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
  *  $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.BILL.DETAILS
  *  $INSERT I_AA.APP.COMMON
    $USING APAP.TAM
    $USING AA.Framework

    GOSUB OPENFILES
    GOSUB GET.LOCAL.REF
    GOSUB LOCATE.PROCESS
RETURN
**********
OPENFILES:
**********
    Y.USER              = '' ; Y.PORT.FOL.TYPE     = '' ; Y.PROD.TYPE         = '' ; Y.REST.ST.DATE      = '' ; Y.REST.ED.DATE      = '' ; Y.PORT.TYPE         = '' ; ARR.INFO = ''
    FN.CUSTOMER                 = 'F.CUSTOMER' ; F.CUSTOMER                   = '' ; Y.OUT.DATE          = '' ; Y.OUT.DATE1         = ''
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
    FN.AA.ARRANGEMENT.DATED.XREF = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)
RETURN

**************
GET.LOCAL.REF:
**************
    APPL.ARRAY           = 'AA.ARR.OVERDUE'
    FLD.ARRAY            = 'L.LOAN.STATUS':@VM:'L.STATUS.CHG.DT':@VM:'L.LOAN.COND'
    FLD.POS              = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.LOAN.STATUS.POS  = FLD.POS<1,1>
    L.STATUS.CHG.DT.POS  = FLD.POS<1,2>
    L.LOAN.COND.POS = FLD.POS<1,3>
RETURN

***************
LOCATE.PROCESS:
***************
    LOCATE "PORT.FOL.TYPE" IN D.FIELDS<1> SETTING Y.PRD.GRP.POS THEN
        Y.PORT.FOL.TYPE = D.RANGE.AND.VALUE<Y.PRD.GRP.POS>
    END
    LOCATE "RESTR.FROM.DATE" IN D.FIELDS<1> SETTING Y.FRM.POS THEN
        Y.REST.ST.DATE  = D.RANGE.AND.VALUE<Y.FRM.POS>
    END
    LOCATE "RESTR.TILL.DATE" IN D.FIELDS<1> SETTING Y.TO.POS THEN
        Y.REST.ED.DATE  = D.RANGE.AND.VALUE<Y.TO.POS>
    END
    IF Y.REST.ST.DATE GT Y.REST.ED.DATE THEN
        ENQ.ERROR = 'EB-FROM.DATE.GREATER'
        RETURN
    END
    LOCATE "PROD.TYPE" IN D.FIELDS<1> SETTING Y.PRD.POS THEN
        Y.PROD.TYPE     = D.RANGE.AND.VALUE<Y.PRD.POS>
    END
    LOCATE "Y.USR" IN D.FIELDS<1> SETTING Y.USR.POS THEN
        Y.USER          = D.RANGE.AND.VALUE<Y.USR.POS>
    END


    SEL.CMD.ACC = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.GROUP EQ " :Y.PORT.FOL.TYPE
    CALL EB.READLIST(SEL.CMD.ACC,SEL.CMD.LIST,'',NO.OF.REC,SEL.CMD.ERR)
    LOOP
        REMOVE Y.ARRANGE.ID FROM SEL.CMD.LIST SETTING Y.AA.POS
    WHILE Y.ARRANGE.ID : Y.AA.POS
        *CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGE.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
        R.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.ARRANGE.ID, ARR.ERR) ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
        ArrangementID        = Y.ARRANGE.ID ; idPropertyClass = 'OVERDUE'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
       * CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
        AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
        R.CONDITION          = RAISE(returnConditions)
        Y.REST.ST = R.CONDITION<AA.OD.LOCAL.REF,L.LOAN.STATUS.POS>
        Y.REST.CD = R.CONDITION<AA.OD.LOCAL.REF,L.LOAN.COND.POS>
        Y.ERR.FLAG = ''
        IF Y.REST.ST EQ 'Restructured' OR Y.REST.CD EQ 'Restructured' THEN
            GOSUB CHECK.DATED.REF
        END
    REPEAT

RETURN

CHECK.DATED.REF:

   * CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,Y.ARRANGE.ID,R.ARR.XREF,F.AA.ARRANGEMENT.DATED.XREF,XREF.ERR)
    R.ARR.XREF = AA.Framework.ArrangementDatedXref.Read(Y.ARRANGE.ID, XREF.ERR) ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    Y.PRO = R.ARR.XREF<1>
    LOCATE 'APAP.OVERDUE' IN Y.PRO<1,1> SETTING POS.PR THEN
        Y.REST.DT = R.ARR.XREF<2,POS.PR,1>
        Y.REST.DT = FIELD(Y.REST.DT,'.',1)
        IF Y.REST.DT GE Y.REST.ST.DATE AND Y.REST.DT LE Y.REST.ED.DATE THEN
            GOSUB CHECK.OT.DET
        END
    END

RETURN

CHECK.OT.DET:

    GOSUB FETCH.USER.DETAILS
    GOSUB CHECK.ARRANGEMENT.DETAILS
    IF Y.ERR.FLAG EQ '' THEN
        GOSUB MAIN.PROCESS
    END

RETURN
*******************
FETCH.USER.DETAILS:
*******************
    IN.PROPERTY.CLASS  = 'OVERDUE'
    OUT.PROPERTY       = ''
    R.OUT.AA.RECORD    = ''
    OUT.ERR            = ''
*    CALL REDO.GET.PROPERTY.NAME(Y.ARRANGE.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.ARRANGE.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR);* R22 Manual Code Conversion
    *CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.ARRANGE.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,Y.ERR.ACT.HIS)
    R.AA.ACTIVITY.HISTORY = AA.Framework.ActivityHistory.Read(Y.ARRANGE.ID, Y.ERR.ACT.HIS);*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    IF R.AA.ACTIVITY.HISTORY THEN
        ORIG.ACT       = "LENDING-UPDATE":"-":OUT.PROPERTY
        *Y.ACT          = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        Y.ACT          = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
        ACT.COUNT.VM   = DCOUNT(Y.ACT,@VM)
        CNT            = 1
        LOOP
        WHILE CNT LE ACT.COUNT.VM
*Y.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,CNT>
            Y.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity,CNT>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
            GOSUB CHK.ACTS
            CNT += 1
        REPEAT
    END
RETURN

CHK.ACTS:

    LOCATE ORIG.ACT IN Y.ACTIVITY<1,1,1> SETTING Y.POS THEN
        *Y.STAT = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS,CNT,Y.POS>
        Y.STAT = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActStatus,CNT,Y.POS>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
        IF Y.STAT EQ 'AUTH' THEN
           * Y.ARR.ACT.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,CNT,Y.POS>
            Y.ARR.ACT.ID = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActivityRef,CNT,Y.POS>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
           * CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ARR.ACT.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ACT.ERR)
    R.AA.ARRANGEMENT.ACTIVITY = AA.Framework.ArrangementActivity.Read(Y.ARR.ACT.ID, ACT.ERR);*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
            *TXN.INPUT          = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INPUTTER>
             TXN.INPUT          = R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.ArrangementActivity.ArrActInputter>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
            TRANSACTION.USER   = FIELD(TXN.INPUT,'_',2,1)
           * TXN.AUTHOR         = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.AUTHORISER>
              TXN.AUTHOR         = R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.SimulationCapture.ArrActAuthoriser>;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
            AUTHORISING.USER   = FIELD(TXN.AUTHOR,'_',2,1)

            CNT = ACT.COUNT.VM + 1
        END
    END

RETURN
**************************
CHECK.ARRANGEMENT.DETAILS:
**************************

   * IF Y.PROD.TYPE AND Y.PROD.TYPE NE R.ARRANGEMENT<AA.ARR.PRODUCT> THEN
    IF Y.PROD.TYPE AND Y.PROD.TYPE NE R.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct> THEN ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
        Y.ERR.FLAG = 1
        RETURN
    END
    IF Y.USER THEN
        IF Y.USER NE TRANSACTION.USER THEN
            IF Y.USER NE AUTHORISING.USER THEN
                Y.ERR.FLAG = 1
            END
        END
        RETURN
    END
RETURN
*************
MAIN.PROCESS:
*************
    GOSUB GET.AA.DETAILS
    GOSUB GET.AA.INTEREST.ACCRUALS.DETAILS
    GOSUB GET.BILL.AMOUNT.DETAILS
    GOSUB GET.TERM.AMOUNT.DETAILS
    GOSUB GET.BILL.PAYMENT.DETAILS
    GOSUB GET.PAYMENT.TYPE.DETAILS
    Y.OUT.ARRAY<-1> = LOAN.NUM:"*":PREV.LOAN.NUM:"*":PRIME.NAME:"*":PORTFOLIO.TYPE:"*":PRODUCT:"*":LOAN.ORIGIN.AGENCY:"*":Y.REST.DT:"*":PREV.PAY.TYPE:"*":CURR.PAY.TYPE:"*":PREV.BILL.PAY.DATE:"*":CURR.BILL.PAY.DATE:"*":PREV.DUE.RATE:"*":CURR.DUE.RATE:"*":PREV.INT.RATE:"*":CURR.INT.RATE:"*":PREV.BILL.AMOUNT:"*":CURR.BILL.AMOUNT:"*":PREV.DUE.DATE:"*":CURR.DUE.DATE:"*":TRANSACTION.USER:"*":AUTHORISING.USER
    PRIME.NAME = '' ; Y.PRIM = '' ; TRANSACTION.USER = '' ; AUTHORISING.USER = '' ; PREV.PAY.TYPE = '' ; CURR.PAY.TYPE = '' ; PREV.BILL.PAY.DATE = '' ; CURR.BILL.PAY.DATE = '' ; PREV.DUE.RATE = '' ; CURR.DUE.RATE = '' ;
    PREV.INT.RATE = '' ; CURR.INT.RATE = '' ; PREV.BILL.AMOUNT = '' ; CURR.BILL.AMOUNT = '' ; PREV.DUE.DATE = '' ; CURR.DUE.DATE = ''
RETURN

***************
GET.AA.DETAILS:
***************

    LOAN.NUM           = Y.ARRANGE.ID
*    PORTFOLIO.TYPE     = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
*    PRODUCT            = R.ARRANGEMENT<AA.ARR.PRODUCT>
*    Y.ARR.CUST         = R.ARRANGEMENT<AA.ARR.CUSTOMER>
*    Y.AA.CURR          = R.ARRANGEMENT<AA.ARR.CURRENCY>
*    LOAN.ORIGIN.AGENCY = R.ARRANGEMENT<AA.ARR.CO.CODE>
 ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED-START   
     PORTFOLIO.TYPE     = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup>
    PRODUCT            = R.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct>
    Y.ARR.CUST         = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCustomer>
    Y.AA.CURR          = R.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
    LOAN.ORIGIN.AGENCY = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCoCode>
;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED-STOP
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,LOAN.NUM,R.AA.ACCOUNT,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    CURR.DUE.DATE      = R.AA.ACCOUNT<AA.AD.MATURITY.DATE>
    GOSUB GET.ARR.ACC.DETAILS
    GOSUB GET.ARR.CUS.DETAILS

RETURN

GET.ARR.ACC.DETAILS:

    ArrangementID      = Y.ARRANGE.ID ; idPropertyClass = 'ACCOUNT'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = '';  idProperty = ''
    *CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Manual Code Conversion-CALL RTN MODIFIED
    R.CONDITION          = RAISE(returnConditions)
    PREV.LOAN.NUM      = R.CONDITION<AA.AC.ALT.ID>
RETURN

GET.ARR.CUS.DETAILS:

    ArrangementID   = Y.ARRANGE.ID ; idPropertyClass = 'CUSTOMER'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
    *CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError) ;* R22 Manual Code Conversion-CALL RTN MODIFIED
    R.CONDITION     = RAISE(returnConditions)
*Y.PRIM.CUST     = R.CONDITION<AA.CUS.PRIMARY.OWNER>
    Y.PRIM.CUST     = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 MANUAL CONVERSION
*Y.OWNER.CUST    = R.CONDITION<AA.CUS.OWNER>
    Y.OWNER.CUST    = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 MANUAL CONVERSION
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


*********************************
GET.AA.INTEREST.ACCRUALS.DETAILS:
*********************************
 *   CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGE.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
   R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.ARRANGE.ID, ARR.ERR);*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
   * Y.EFF.DATE    = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
     Y.EFF.DATE    = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProdEffDate>  ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
    ARR.INFO      = '' ; ARR.INFO<1>   = Y.ARRANGE.ID ; R.ARRANGEMENT = ''
    *CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)
     AA.Framework.GetArrangementProperties(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST) ;* R22 Manual Code Conversion-CALL RTN MODIFIED
    CLASS.LIST   = '' ; INT.PROPERTY = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)         ;* Find their Property classes
    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST  = RAISE(PROP.LIST)
    CLASS.CTR  = ''
    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR += 1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "INTEREST" THEN
            INT.PROPERTY<-1> = PROP.LIST<CLASS.CTR>
        END
        IF Y.CLASS EQ "PAYMENT.SCHEDULE" THEN
            PS.PROPERTY = PROP.LIST<CLASS.CTR>
        END
        IF Y.CLASS EQ "TERM.AMOUNT" THEN
            TERM.PROP   = PROP.LIST<CLASS.CTR>
        END
    REPEAT
    CHANGE @FM TO '*' IN INT.PROPERTY
    Y.COUNT.PROP = DCOUNT(INT.PROPERTY,'*')
    INIT = 1
    LOOP
    WHILE INIT LE Y.COUNT.PROP
        Y.FIRST.PROP = FIELD(INT.PROPERTY,'*',INIT)
        AA.INTEREST.ACCRUALS.ID = Y.ARRANGE.ID:'-':Y.FIRST.PROP ;* form the accrual id using the property
        CALL F.READ(FN.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ER)
        Y.ACC.ST.DATE  = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.PERIOD.START>
        Y.ACC.END.DATE = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.PERIOD.END>
        Y.FROM.DATE    = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.FROM.DATE>
        Y.TO.DATE      = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.TO.DATE>
        IF Y.ACC.ST.DATE EQ '' THEN
            GOSUB FETCH.PENALTY.RATE
        END ELSE
            GOSUB FETCH.INTEREST.RATE
        END
        INIT += 1
    REPEAT
RETURN
*******************
FETCH.PENALTY.RATE:
*******************
    ERR.FLAG = '' ; FRM.CNT = DCOUNT(Y.FROM.DATE,@VM) ; TO.CNT  = DCOUNT(Y.TO.DATE,@VM)
    CNT = 1
    LOOP
    WHILE CNT LE FRM.CNT
        Y.FRM.DT.CNT = FIELD(Y.FROM.DATE,@VM,CNT)
        Y.TO.DT.CNT  = FIELD(Y.TO.DATE,@VM,CNT)
        IF ERR.FLAG EQ '1' THEN
            RETURN
        END
        IF Y.REST.DT GE Y.FRM.DT.CNT AND Y.REST.DT LE Y.TO.DT.CNT THEN
            PREV.DUE.RATE  = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,CNT,1>
            ERR.FLAG = 1
        END
        CNT += 1
    REPEAT
    CURR.DUE.RATE          = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>
RETURN
********************
FETCH.INTEREST.RATE:
********************
    ERR.FLAG = '' ; FRM.CNT  = DCOUNT(Y.FROM.DATE,@VM) ; TO.CNT   = DCOUNT(Y.TO.DATE,@VM)
    CNT = 1
    LOOP
    WHILE CNT LE FRM.CNT
        Y.FRM.DT.CNT = FIELD(Y.FROM.DATE,@VM,CNT)
        Y.TO.DT.CNT  = FIELD(Y.TO.DATE,@VM,CNT)
        IF ERR.FLAG EQ '1' THEN
            RETURN
        END
        IF Y.REST.DT GE Y.FRM.DT.CNT AND Y.REST.DT LE Y.TO.DT.CNT THEN
            PREV.INT.RATE  = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,CNT,1>
            ERR.FLAG = 1
        END
        CNT += 1
    REPEAT
    CURR.INT.RATE          = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>
RETURN
************************
GET.BILL.AMOUNT.DETAILS:
************************
    OPTION       = '' ; R.PROPERTY   = '' ; RET.ERROR  = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
    *ID.COMPONENT = '' ; ID.COMPONENT<AA.IDC.ARR.NO>    = Y.ARRANGE.ID
    ID.COMPONENT = '' ; ID.COMPONENT<AA.Framework.IdcArrNo>    = Y.ARRANGE.ID ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
   * ID.COMPONENT<AA.IDC.PROPERTY> = PS.PROPERTY
    ID.COMPONENT<AA.Framework.IdcProperty> = PS.PROPERTY ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
    Y.EFFECTIVE.DATE              = TODAY
*ID.COMPONENT<AA.IDC.EFF.DATE> = Y.EFFECTIVE.DATE
     ID.COMPONENT<AA.Framework.IdcEffDate> = Y.EFFECTIVE.DATE ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
*    CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
     AA.Framework.GetPreviousPropertyRecord(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR) ;* R22 Manual Code Conversion-CALL RTN MODIFIED
    ;* R22 Manual Code Conversion-CALL RTN MODIFIED
    Y.CALC.AMOUNT   = R.PROPERTY<AA.PS.CALC.AMOUNT>
    Y.ACTUAL.AMOUNT = R.PROPERTY<AA.PS.ACTUAL.AMT>
    IF Y.CALC.AMOUNT NE '' THEN
        PREV.BILL.AMOUNT = Y.CALC.AMOUNT
    END ELSE
        PREV.BILL.AMOUNT = Y.ACTUAL.AMOUNT
    END
    ArrangementID  = Y.ARRANGE.ID ;  R.CONDITION       = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
    returnIds      = '' ; returnConditions = '' ; returnError = '' ; idProperty = '' ; effectiveDate  = ''
   * CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError);* R22 Manual Code ConversioN- CALL RTN MODIFIED
    R.CONDITION          = RAISE(returnConditions)
    Y.CALC.AMOUNT        = R.CONDITION<AA.PS.CALC.AMOUNT>
    Y.ACTUAL.AMOUNT      = R.CONDITION<AA.PS.ACTUAL.AMT>
    IF Y.CALC.AMOUNT NE '' THEN
        CURR.BILL.AMOUNT = Y.CALC.AMOUNT
    END ELSE
        CURR.BILL.AMOUNT = Y.ACTUAL.AMOUNT
    END
RETURN
************************
GET.TERM.AMOUNT.DETAILS:
************************
    OPTION       = '' ; R.PROPERTY   = '' ; RET.ERROR  = '' ; idPropertyClass = "TERM.AMOUNT"
  *  ID.COMPONENT = '' ; ID.COMPONENT<AA.IDC.ARR.NO>    = Y.ARRANGE.ID
    ID.COMPONENT = '' ; ID.COMPONENT<AA.Framework.IdcArrNo>    = Y.ARRANGE.ID ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
    *ID.COMPONENT<AA.IDC.PROPERTY> = TERM.PROP
    ID.COMPONENT<AA.Framework.IdcProperty> = TERM.PROP ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
    Y.EFFECTIVE.DATE              = TODAY
  *  ID.COMPONENT<AA.IDC.EFF.DATE> = Y.EFFECTIVE.DATE
    ID.COMPONENT<AA.Framework.IdcEffDate> = Y.EFFECTIVE.DATE ;* R22 Manual Code Conversion-AA.FRAMEWORK CHANGED
   * CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
    AA.Framework.GetPreviousPropertyRecord(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
    PREV.DUE.DATE  = R.PROPERTY<AA.AMT.MATURITY.DATE>
RETURN
*************************
GET.BILL.PAYMENT.DETAILS:
*************************
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRANGE.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    IF NOT(R.ACCOUNT.DETAILS<AA.AD.BILL.ID>) THEN
        Y.PAY.ST.DATE = R.ACCOUNT.DETAILS<AA.AD.PAYMENT.START.DATE>
        GOSUB FETCH.CURR.PAYMENT.FREQUENCY
        CALL EB.CYCLE.RECURRENCE(CURR.PAYMENT.FREQ,Y.PAY.ST.DATE,Y.OUT.DATE)
        CURR.BILL.PAY.DATE = Y.OUT.DATE
    END
    IF R.ACCOUNT.DETAILS<AA.AD.BILL.ID> THEN
        Y.BILL.ID  = R.ACCOUNT.DETAILS<AA.AD.BILL.ID,1,1>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BIL.ERR)
        Y.PAY.DATE  = R.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        Y.BILL.DATE = R.BILL.DETAILS<AA.BD.BILL.DATE,1>
        Y.STATUS    = R.BILL.DETAILS<AA.BD.BILL.STATUS,1,1>
        IF Y.REST.DT GT Y.BILL.DATE THEN
            CURR.BILL.PAY.DATE = R.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        END
        IF Y.REST.DT LT Y.BILL.DATE THEN
            IF Y.STATUS EQ "DUE" THEN
                CURR.BILL.PAY.DATE = Y.BILL.DATE
            END
            IF Y.STATUS EQ "SETTLED" THEN
                GOSUB FETCH.CURR.PAYMENT.FREQUENCY
                CALL EB.CYCLE.RECURRENCE(CURR.PAYMENT.FREQ,Y.BILL.DATE,Y.OUT.DATE)
                CURR.BILL.PAY.DATE = Y.OUT.DATE
            END
        END
    END
    IF NOT(R.ACCOUNT.DETAILS<AA.AD.BILL.ID>) THEN
        Y.PAY.ST.DATE = R.ACCOUNT.DETAILS<AA.AD.PAYMENT.START.DATE>
        GOSUB FETCH.PREV.PAYMENT.FREQUENCY
        CALL EB.CYCLE.RECURRENCE(PREV.PAYMENT.FREQ,Y.PAY.ST.DATE,Y.OUT.DATE1)
        PREV.BILL.PAY.DATE    = Y.OUT.DATE1
    END
    IF R.ACCOUNT.DETAILS<AA.AD.BILL.ID> THEN
        Y.BILL.ID = R.ACCOUNT.DETAILS<AA.AD.BILL.ID,1,1>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BIL.ERR)
        Y.PAY.DATE  = R.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        Y.BILL.DATE = R.BILL.DETAILS<AA.BD.BILL.DATE>
        Y.STATUS    = R.BILL.DETAILS<AA.BD.BILL.STATUS,1,1>
        IF Y.REST.DT GT Y.BILL.DATE THEN
            PREV.BILL.PAY.DATE = R.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        END
        IF Y.REST.DT LT Y.BILL.DATE THEN
            IF Y.STATUS EQ "DUE" THEN
                GOSUB FETCH.PREV.PAYMENT.FREQUENCY
                CALL EB.CYCLE.RECURRENCE(PREV.PAYMENT.FREQ,Y.PAY.DATE,Y.OUT.DATE1)
                PREV.BILL.PAY.DATE = Y.OUT.DATE1
            END
            IF Y.STATUS EQ "SETTLED" THEN
                GOSUB FETCH.PREV.PAYMENT.FREQUENCY
                CALL EB.CYCLE.RECURRENCE(PREV.PAYMENT.FREQ,Y.BILL.DATE,Y.OUT.DATE1)
                PREV.BILL.PAY.DATE    = Y.OUT.DATE1
            END
        END
    END
RETURN
*************************
GET.PAYMENT.TYPE.DETAILS:
*************************
    OPTION       = '' ; R.PROPERTY   = '' ; RET.ERROR  = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
    *ID.COMPONENT = '' ; ID.COMPONENT<AA.IDC.ARR.NO>    = Y.ARRANGE.ID
    ID.COMPONENT = '' ; ID.COMPONENT<AA.Framework.IdcArrNo>    = Y.ARRANGE.ID ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    *ID.COMPONENT<AA.IDC.PROPERTY> = PS.PROPERTY
    ID.COMPONENT<AA.Framework.IdcProperty> = PS.PROPERTY ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    Y.EFFECTIVE.DATE              = TODAY
    *ID.COMPONENT<AA.IDC.EFF.DATE> = Y.EFFECTIVE.DATE
    ID.COMPONENT<AA.Framework.IdcEffDate> = Y.EFFECTIVE.DATE ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    *CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
    AA.Framework.GetPreviousPropertyRecord(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR);*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
    PREV.PAY.TYPE        = R.PROPERTY<AA.PS.PAYMENT.TYPE>

    ArrangementID  = Y.ARRANGE.ID ;  R.CONDITION       = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
    returnIds      = '' ; returnConditions = '' ; returnError = '' ; idProperty = '' ; effectiveDate  = ''
    *CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError) ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
    R.CONDITION          = RAISE(returnConditions)
    CURR.PAY.TYPE        = R.CONDITION<AA.PS.PAYMENT.TYPE>
RETURN
*****************************
FETCH.CURR.PAYMENT.FREQUENCY:
*****************************
    ArrangementID  = Y.ARRANGE.ID ;  R.CONDITION      = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
    returnIds      = '' ; returnConditions = '' ; returnError = '' ; idProperty = '' ; effectiveDate  = ''
   * CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError)
     AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions,returnError) ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
    R.CONDITION           = RAISE(returnConditions)
    CURR.PAYMENT.FREQ     = R.CONDITION<AA.PS.PAYMENT.FREQ>
RETURN
*****************************
FETCH.PREV.PAYMENT.FREQUENCY:
*****************************
    OPTION       = '' ; R.PROPERTY   = '' ; RET.ERROR  = '' ; idPropertyClass = "PAYMENT.SCHEDULE"
   * ID.COMPONENT = '' ; ID.COMPONENT<AA.IDC.ARR.NO>    = Y.ARRANGE.ID
    ID.COMPONENT = '' ; ID.COMPONENT<AA.Framework.IdcArrNo>    = Y.ARRANGE.ID    ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
   * ID.COMPONENT<AA.IDC.PROPERTY> = PS.PROPERTY
    ID.COMPONENT<AA.Framework.IdcProperty> = PS.PROPERTY ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
    Y.EFFECTIVE.DATE              = TODAY
  *  ID.COMPONENT<AA.IDC.EFF.DATE> = Y.EFFECTIVE.DATE
     ID.COMPONENT<AA.Framework.IdcEffDate> = Y.EFFECTIVE.DATE ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK CHANGED
   * CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
    AA.Framework.GetPreviousPropertyRecord(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.PROPERTY, RET.ERROR) ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
    PREV.PAYMENT.FREQ = R.PROPERTY<AA.PS.PAYMENT.FREQ>
RETURN
*-------------------------------------------------------------------------------------
END
