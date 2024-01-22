* @ValidationCode : MjoxNjM5MDExMTUxOlVURi04OjE3MDU5MTc2MjQyNTA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:30:24
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.ENQ.SHOW.LOAN.PAY.ACCT(LOAN.LIST)

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00108342          Prabhu N                MODIFICAION
*19/06/15      PACS00459919          Aslam                   MODIFICATION
*10/08/15      PACS00459919    Aslam                   MODIFICATION
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , FM to @FM , SM to @SM , ++ to += and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*18-12-2023         VIGNESHWARI            R22 Manual Conversion - CALL RTN MODIFIED
* 19-01-2024         Narmadha V            R22 Utility changes,Manual R22 Conversion  - Call Routine modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.OVERDUE
* $INSERT I_F.AA.ACCOUNT.DETAILS ;*Manual R22 Conversion
* $INSERT I_F.AA.BILL.DETAILS ;*Manual R22 Conversion
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $USING APAP.TAM
    $USING APAP.AA
    $USING AA.PaymentSchedule ;*Manual R22 Conversion
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

    GOSUB INITIALISE
    GOSUB GET.LOAN.DETAILS
    GOSUB PERFORM.FINAL.ARRAY
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    LR.APP = 'AA.PRD.DES.OVERDUE':@FM:'AA.PRD.DES.TERM.AMOUNT'
    LR.FLDS = 'L.LOAN.COND':@VM:'L.LOAN.STATUS.1':@FM:'L.AA.PART.ALLOW':@VM:'L.AA.PART.PCNT'
    LR.POS = ''
    LOAN.LIST.ACCOUNTS=''
    EB.LKP.LOAN.COND.ID=''
    EB.LKP.LOAN.STATUS.ID=''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
    OD.LOAN.COND.POS =  LR.POS<1,1>
    OD.LOAN.STATUS.POS = LR.POS<1,2>
    L.APP.PART.POS=LR.POS<2,1>
    L.APP.PCNT.POS=LR.POS<2,2>
    FN.CUS.ACC = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACC = ''
    CALL OPF(FN.CUS.ACC,F.CUS.ACC)

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

    FN.AA.ACC.DET = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACC.DET = ''
    CALL OPF(FN.AA.ACC.DET,F.AA.ACC.DET)

    FN.AA.BILL.DET = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DET = ''
    CALL OPF(FN.AA.BILL.DET,F.AA.BILL.DET)

    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    CALL OPF(FN.ARR,F.ARR)

    FN.AA.PROD = 'F.AA.PRODUCT'
    F.AA.PROD = ''
    CALL OPF(FN.AA.PROD,F.AA.PROD)

    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    F.AI.REDO.ACCT.RESTRICT.PARAMETER  = ''
    CALL OPF(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,F.AI.REDO.ACCT.RESTRICT.PARAMETER)

*CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,IDVAR.1,R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR);* R22 Utility Changes
    Y.PARAM.LOAN.STATUS =  R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.LOAN.ACCT.STATUS>
    CHANGE @VM TO @FM IN Y.PARAM.LOAN.STATUS
    CUST.ID= System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	  ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUST.ID = ""
    END

    FN.REDO.CUSTOMER.ARRANGEMENT='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT=''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    CALL F.READ(FN.CUS.ACC,CUST.ID,R.CUSTOMER.ACCOUNT.REC,F.CUS.ACC,CUS.ACC.ERR)
*    APP.LOC = 'AA.PRD.DES.TERM.AMOUNT'
*    L.APP.FIELDS='L.AA.PART.ALLOW':VM:'L.AA.PART.PCNT'
*    CALL MULTI.GET.LOC.REF(APP.LOC,L.APP.FIELDS,L.APP.POS)
*    L.APP.PART.POS=L.APP.POS<1,1>
*    L.APP.PCNT.POS=L.APP.POS<1,2>



    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,CUST.ID,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)

    Y.OTHER=R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    Y.OTHER.CNT=DCOUNT(Y.OTHER,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.OTHER.CNT
        Y.ARR.ID=Y.OTHER<1,Y.VAR2>
        CALL F.READ(FN.ARR,Y.ARR.ID,R.ARR.REC1,F.ARR,ARR.ERR)


        EFF.DATE = ''
        PROP.CLASS='CUSTOMER'
        PROPERTY = ''
        R.CONDITION = ''
        ERR.MSG = ''
        APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
*--------------------PACS00459919---------------------------------------------------------

        LOCATE CUST.ID IN R.CONDITION<AA.CUS.OTHER.PARTY,1> SETTING OTHER.POS THEN
            Y.ROLE = R.CONDITION<AA.CUS.ROLE,OTHER.POS>

            IF Y.ROLE EQ "CO-SIGNER" THEN
                R.CUSTOMER.ACCOUNT.REC<-1> = R.ARR.REC1<AA.ARR.LINKED.APPL.ID,1>
            END
            Y.VAR2 += 1
        END
*-------------------PACS00459919----------------------------------------------------------
    REPEAT

RETURN
*----------------------------------------------------------------------------
GET.LOAN.DETAILS:
*-----------------------------------------------------------------------------



    LOAN.LIST=''
    EB.LKP.LOAN.COND.ID = 'L.LOAN.STATUS.1'
    CALL EB.LOOKUP.LIST(EB.LKP.LOAN.COND.ID)
    LOOKUP.LOAN.COND = EB.LKP.LOAN.COND.ID<2>
    CHANGE '_' TO @VM IN LOOKUP.LOAN.COND

    EB.LKP.LOAN.STATUS.ID = 'L.LOAN.COND'
    CALL EB.LOOKUP.LIST(EB.LKP.LOAN.STATUS.ID)
    LOOKUP.LOAN.STATUS=EB.LKP.LOAN.STATUS.ID<2>
    CHANGE '_' TO @VM IN LOOKUP.LOAN.STATUS
RETURN

*******************
PERFORM.FINAL.ARRAY:
*******************


    LOOP
        REMOVE ACC.ID FROM R.CUSTOMER.ACCOUNT.REC SETTING ACCT.POS
    WHILE ACC.ID:ACCT.POS

        LOAN.FLAG=''
        Y.LOOP.CONTINUE = ''
        GOSUB CHECK.LOAN.ACCT
        IF ARR.ID NE '' THEN
*  CALL REDO.CONVERT.ACCOUNT(ACC.ID,Y.ARR.ID,ARR.ID,ERR.TEXT)
            PROP.CLASS = 'OVERDUE'
            PROPERTY = ''
            R.Condition = ''
            ERR.MSG = ''
            EFF.DATE = ''
            APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
            LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
            LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
            GOSUB CHECK.LOAN.STATUS
            IF NOT(Y.LOOP.CONTINUE) THEN

                GOSUB READ.AA.ACCT.DETAILS
                GOSUB READ.AA.BILL.DETAILS
                GOSUB GET.NEXT.BILL.DUE
                GOSUB CHECK.MINAUS.PART.AMT
            END
        END
    REPEAT

RETURN
**********************
CHECK.LOAN.STATUS:
**********************
    IF Y.PARAM.LOAN.STATUS THEN
        IF LOAN.STATUS OR LOAN.COND THEN
            LOCATE LOAN.STATUS IN Y.PARAM.LOAN.STATUS SETTING LOAN.ACCT.POS THEN
                Y.LOOP.CONTINUE=1
            END
            LOCATE LOAN.COND IN Y.PARAM.LOAN.STATUS SETTING LOAN.ACCT.POS THEN
                Y.LOOP.CONTINUE=1
            END
        END
    END
RETURN
**********************
CHECK.MINAUS.PART.AMT:
***********************
*    IF Y.TOT.BILL.AMT GT 0 AND ARR.STATUS.CHECK EQ 'CURRENT' THEN
    IF Y.TOT.BILL.AMT GT 0 THEN
        VAR.CCY = LCCY
        VAR.DIGIT = '2'
        CALL EB.ROUND.AMOUNT(VAR.CCY,BILL.MINUS.PART.AMT,VAR.DIGIT,'')
        LOAN.LIST<-1> = ARR.ID:"@":ARR.ACCT.BAL:"@":EXACT.AMT:"@":ACC.ID:"@":ARR.OPEN.DTE:"@":ARR.TERM.AMT:"@":ARR.BAL.OUT:"@":ARR.PRODUCT:"@":TOT.UNP.BILL.CNT:"@":BILL.MINUS.PART.AMT:'@':Y.BILL.AMT.LIST:'@':Y.EXACT.DATE:'@':Y.TOT.BILL.AMT
    END
RETURN
****************
CHECK.LOAN.ACCT:
***************

    R.ACC= ''
    ACC.ERR = ''
    CALL F.READ(FN.ACC,ACC.ID,R.ACC,F.ACC,ACC.ERR)
    R.ECB='' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACC.ID,R.ECB,ECB.ERR) ;*Tus End
    IF R.ACC THEN
        ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
* ARR.ACCT.BAL = R.ACC<AC.ONLINE.ACTUAL.BAL>;*Tus Start
        ARR.ACCT.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End
    END

RETURN
**********************
READ.AA.ACCT.DETAILS:
**********************

    ARR.OPEN.DTE=''
    ARR.TERM.AMT=''
    ARR.BAL.OUT=''


    CALL F.READ(FN.ARR,ARR.ID,R.ARR.REC,F.ARR,ARR.ERR)
    IF R.ARR.REC THEN
        ARR.OPEN.DTE = R.ARR.REC<AA.ARR.START.DATE>
        ARR.PRODUCT = R.ARR.REC<AA.ARR.PRODUCT>
        ARR.STATUS.CHECK = R.ARR.REC<AA.ARR.ARR.STATUS>
        APAP.TAM.redoAaGetOutBalance(ARR.ID,Y.BALANCE)
        ARR.BAL.OUT = Y.BALANCE
        Y.TERM.AMOUNT=0
        EFF.DATE = ''

        PROP.CLASS='TERM.AMOUNT'
        PROPERTY = ''
        R.CONDITION = ''
        ERR.MSG = ''
        APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
        ARR.TERM.AMT=R.CONDITION<AA.AMT.AMOUNT>
        PART.PAY=R.CONDITION<AA.AMT.LOCAL.REF,L.APP.PART.POS>
        PART.PCNT=R.CONDITION<AA.AMT.LOCAL.REF,L.APP.PCNT.POS>

    END
    GET.FULL.DET = ''
    O.DATA = ARR.ID
    TOT.BILL.DET =''
    TOT.BILL.CNT = ''
    CALL E.AA.GET.BILLS.CONVERSION
    GET.FULL.DET = R.RECORD
*    TOT.BILL.DET = R.RECORD<AA.AD.BILL.ID>
    TOT.BILL.DET = R.RECORD<AA.PaymentSchedule.AccountDetailsHist.AdBillId> ;*Manual R22 Conversion
    CHANGE @VM TO @FM IN TOT.BILL.DET
    TOT.BILL.CNT = DCOUNT(TOT.BILL.DET,@FM)
*    CALL System.setVariable('CURRENT.TOT.BILL.CNT',TOT.BILL.CNT)
*    TOT.BILL.STATUS = R.RECORD<AA.AD.SET.STATUS>
    TOT.BILL.STATUS = R.RECORD<AA.PaymentSchedule.AccountDetails.AdSetStatus> ;*Manual R22 Conversion

RETURN
**********************
READ.AA.BILL.DETAILS:
**********************
    BILL.CNT=''
    EXACT.AMT=''
    BILL.CNT = 1
    TOT.UNP.BILL.CNT=0
    CHECK.BILL.AMT=''
    FIRST.BILL.PART.AMT=''
    FIRST.AMT.TO.SUB=''
    PART.FLG=''
    BILL.MINUS.PART.AMT=''
    EXACT.PART.AMT=''
    Y.OLD.BILL.SET=''
    Y.TOT.BILL.AMT = 0
    Y.BILL.AMT.LIST=0


    LOOP

    WHILE BILL.CNT LE TOT.BILL.CNT

*EACH.BILL.ID=GET.FULL.DET<AA.AD.BILL.ID,BILL.CNT>
        EACH.BILL.ID=GET.FULL.DET<  AA.PaymentSchedule.AccountDetailsHist.AdBillId,BILL.CNT> ;*Manual R22 Conversion
*EACH.BILL.STATUS = GET.FULL.DET<AA.AD.SET.STATUS,BILL.CNT>
        EACH.BILL.STATUS = GET.FULL.DET<AA.PaymentSchedule.AccountDetails.AdSetStatus,BILL.CNT> ;*Manual R22 Conversion
        IF EACH.BILL.STATUS EQ 'UNPAID' THEN


            R.BILL.DET = ''
            CALL F.READ(FN.AA.BILL.DET,EACH.BILL.ID,R.BILL.DET,F.AA.BILL.DET,BILL.DET.ERR)
            IF R.BILL.DET THEN
* Y.PROPERTY.LIST = R.BILL.DET<AA.BD.PROPERTY>
                Y.PROPERTY.LIST = R.BILL.DET<AA.PaymentSchedule.BillDetailsHist.BdProperty> ;*Manual R22 Conversion
                CHANGE @VM TO @FM IN Y.PROPERTY.LIST
                CHANGE @SM TO @FM IN Y.PROPERTY.LIST

                Y.TOT.PROP.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
                Y.PROP.CNT = 1
                LOOP
                WHILE Y.PROP.CNT LE Y.TOT.PROP.CNT
*    Y.EACH.BILL.AMT + = R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
                    Y.EACH.BILL.AMT + = R.BILL.DET<AA.PaymentSchedule.BillDetails.BdOsPropAmount,Y.PROP.CNT>;*Manual R22 Conversion
                    Y.PROP.CNT += 1

                REPEAT
                Y.TOT.BILL.AMT +  = Y.EACH.BILL.AMT
                Y.BILL.AMT.LIST<BILL.CNT>=Y.EACH.BILL.AMT
                Y.EACH.BILL.AMT = ''1

                GOSUB CHECK.PART.PAY
            END
        END


        BILL.CNT += 1
    REPEAT

    Y.BILL.AMT.LIST = ABS(Y.BILL.AMT.LIST)
    CHANGE @FM TO '#' IN Y.BILL.AMT.LIST
RETURN

******************
GET.NEXT.BILL.DUE:
******************

* CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS);*R22 Manual Conversion - CALL RTN MODIFIED
    Y.DU.DTES = DUE.DATES
    Y.DU.DTES = CHANGE(Y.DU.DTES,@FM,@VM)

    POS.AR = ''
    LOCATE TODAY IN Y.DU.DTES<1,1> BY 'AR' SETTING POS.AR THEN
        POS.AR += 1
        IF Y.DU.DTES<1,POS.AR> EQ TODAY THEN
            POS.AR += 1
        END
    END

    IF POS.AR THEN
        Y.DU.PRPS = DUE.PROPS<POS.AR>
* LOCATE 'ACCOUNT' IN Y.DU.PRPS<1,1,1> SETTING POS.AC THEN
        EXACT.AMT = TOT.PAYMENT<POS.AR>
        Y.EXACT.DATE = DUE.DATES<POS.AR>
* END
    END

RETURN

********************
CHECK.PART.PAY:
********************
    IF PART.PAY EQ 'YES' OR PART.PAY EQ 'SI' THEN


        PART.FLG=1

        GOSUB CHECK.BILL.CNT.ONE

        GOSUB CHECK.BILL.CNT.GT.ONE


        TOT.UNP.BILL.CNT += 1
    END ELSE
* EXACT.AMT += SUM(R.BILL.DET<AA.BD.OS.PROP.AMOUNT>)
        TOT.UNP.BILL.CNT += 1
    END

RETURN
********************
CHECK.BILL.CNT.ONE:
********************
    IF BILL.CNT EQ '1' THEN

*        CHECK.BILL.AMT=R.BILL.DET<AA.BD.OR.TOTAL.AMOUNT>*(PART.PCNT/100)
        CHECK.BILL.AMT=R.BILL.DET<AA.PaymentSchedule.BillDetailsHist.BdOrTotalAmount>*(PART.PCNT/100) ;*Manual R22 Conversion
        FIRST.BILL.PART.AMT=CHECK.BILL.AMT
*       FIRST.AMT.TO.SUB   =SUM(R.BILL.DET<AA.BD.OS.PROP.AMOUNT>)
        FIRST.AMT.TO.SUB   =SUM(R.BILL.DET<AA.PaymentSchedule.BillDetails.BdOsPropAmount>) ;*Manual R22 Conversion

    END


RETURN

*******************
CHECK.BILL.CNT.GT.ONE:
*******************************
    IF BILL.CNT GT '1' THEN
*EXACT.PART.AMT +=SUM(R.BILL.DET<AA.BD.OS.PROP.AMOUNT>)
        EXACT.PART.AMT +=SUM(R.BILL.DET<AA.PaymentSchedule.BillDetails.BdOsPropAmount>) ;*Manual R22 Conversion
    END

RETURN

*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
