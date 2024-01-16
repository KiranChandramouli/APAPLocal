* @ValidationCode : MjoxMzE5MjE0ODM3OkNwMTI1MjoxNzA1MDQ0NzM5NDI4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:02:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.NOFILE.CONT.OVR.DET(Y.ENQ.OUT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.APAP.NOFILE.CONT.OVR.DET
* ODR NO      : ODR-2010-03-0160
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attached in NOFILE ENQUIRY REDO.APAP.CONT.OVR.DET to
*             shows all opened and disbursed loans on or until a specific date

*IN PARAMETER:  NA
*OUT PARAMETER: Y.ENQ.OUT
*LINKED WITH: STANDARD.SELECTION>NOFILE.REDO.CONT.OVR.DET
*----------------------------------------------------------------------

*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion     CALL routine format modified, <AA.CUS.PRIMARY.OWNER>  to <AA.CUS.CUSTOMER>
* 19-12-2023      Narmadha V        Manual R22 Conversion     AA.ARR.CUSTOMER to AA.PRD.DES.CUSTOMER
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.CUSTOMER
*   $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COLLATERAL
 *   $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.INTEREST.ACCRUALS
 *   $INSERT I_F.AA.ACTIVITY.HISTORY
   $USING AA.Framework
   $INSERT I_F.AA.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM

    $USING APAP.TAM
    $USING APAP.REDOENQ
    $USING APAP.AA

    GOSUB INIT
    GOSUB GET.LOCAL.FLDPOS
    GOSUB PROCESS
    GOSUB ASSIGN.VALUES
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''

    FN.AA.ARRANGEMENT.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY=''

* FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'
    FN.AA.ARR.CUSTOMER = 'F.AA.PRD.DES.CUSTOMER'  ;*Manual R22 Conversion AA.ARR.CUSTOMER to AA.PRD.DES.CUSTOMER
    F.AA.ARR.CUSTOMER = ''

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''

    FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS=''

    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''

    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM  = ''

    FN.REDO.FC.CUST.SOLICITUD = 'F.REDO.FC.CUST.SOLICITUD'
    F.REDO.FC.CUST.SOLICITUD  = ''

    CALL OPF(FN.REDO.FC.CUST.SOLICITUD,F.REDO.FC.CUST.SOLICITUD)

    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)

    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS


RETURN
*----------------------------------------------------------------------
GET.LOCAL.FLDPOS:
*----------------
    LOC.REF.APPLICATION="AA.PRD.DES.CUSTOMER":@FM:"CUSTOMER":@FM:"AA.PRD.DES.TERM.AMOUNT":@FM:"COLLATERAL"
    LOC.REF.FIELDS='L.AA.CAMP.TY':@VM:'L.AA.AFF.COM':@FM:'L.CU.CIDENT':@VM:'L.CU.RNC':@FM:'L.AA.COL':@VM:'L.AA.COL.VAL':@FM:'L.COL.VALU.NAM'
    LOC.REF.POS=''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.AA.CAMP.TYPE=LOC.REF.POS<1,1>
    POS.L.AA.AFF.COM=LOC.REF.POS<1,2>
    POS.L.CU.CIDENT=LOC.REF.POS<2,1>
    POS.L.CU.RNC=LOC.REF.POS<2,2>
    POS.L.AA.COL = LOC.REF.POS<3,1>
    POS.L.AA.COL.VAL = LOC.REF.POS<3,2>
    POS.L.COL.VALU.NAM = LOC.REF.POS<4,1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

* THE SELECTION FIELDS ARE LOAN.NUMBER[@ID], LOAN.AGENCY[CO.CODE], LOAN.PORTFOLIO[PRODUCT.GROUP], LOAN.PRODUCT[PRODUCT], DISBURSEMENT.DATE, CAMPAIGN.TYPE
    GOSUB PROCESS.SEL.ARR
    GOSUB PROCESS.SEL.ACT
    GOSUB PROCESS.SEL.CUS

RETURN
*----------------------------------------------------------------------
PROCESS.SEL.ARR:
*---------------
* All selection fields related to AA.ARRANGEMENT application are processed here

    Y.ARR.FLAG = ''
    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''
    LOCATE '@ID' IN FIELDS.BK<1> SETTING POS.ID THEN
        Y.AA.ID = VALUE.BK<POS.ID>
        IF NUM(Y.AA.ID) THEN
            APAP.TAM.redoConvertAccount(Y.AA.ID,'',OUT.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
            VALUE.BK<POS.ID> = OUT.ID
        END
    END


    ARRANGEMENT.APP.FLDS = '@ID':@FM:'CO.CODE':@FM:'PRODUCT.GROUP':@FM:'PRODUCT'
    LOOP
        REMOVE ARR.FLD FROM ARRANGEMENT.APP.FLDS SETTING ARR.FLD.POS
    WHILE ARR.FLD:ARR.FLD.POS
        LOCATE ARR.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            Y.ARR.FLAG = 1
            GOSUB UPDATE.COM.VAR
        END
    REPEAT

    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARRANGEMENT

        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.ARR.CMD) ;*MANUAL R22 CODE CONVERSION
        SEL.AA.ARR.CMD = SEL.AA.ARR.CMD:" AND WITH ARR.STATUS EQ 'AUTH' 'CURRENT' 'EXPIRED' AND PRODUCT.LINE EQ 'LENDING'"
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END ELSE
        SEL.AA.ARR.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH ARR.STATUS EQ 'AUTH' 'CURRENT' 'EXPIRED' AND PRODUCT.LINE EQ 'LENDING'"
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END
RETURN
*----------------------------------------------------------------------
PROCESS.SEL.ACT:
*---------------
* All selection fields related to AA.ARRANGEMENT.ACTIVITY application are processed here

    LOCATE 'EFFECTIVE.DATE' IN FIELDS.BK<1> SETTING EFF.DATE.POS THEN
        Y.VALUE      = VALUE.BK<EFF.DATE.POS>
        Y.OPERAND    = OPERAND.BK<EFF.DATE.POS>
        Y.FIELD      = FIELDS.BK<EFF.DATE.POS>
        GOSUB CHECK.OPERAND.COND
        CHANGE @SM TO @VM IN Y.VALUE
    END ELSE
        Y.VALUE     = ""
        Y.OPERAND   = ""
        Y.FIELD     = ""
    END

RETURN
*----------------------------------------------------------------------
PROCESS.SEL.CUS:
*---------------
* All selection fields related to AA.ARR.CUSTOMER application are processed here

    PROP.CLASS = 'CUSTOMER'
    PROPERTY   = ''
    CAMP.ENQ   = ''
    LOCATE 'L.AA.CAMP.TY' IN FIELDS.BK<1> SETTING CAMP.POS THEN
        CAMP.ENQ = VALUE.BK<CAMP.POS>
        CAMP.OP = OPERAND.BK<CAMP.POS>
        CAMP.OP = OPERAND.LIST<CAMP.OP>
    END
    IF CAMP.ENQ THEN
        LOOP
            REMOVE Y.ARR.ID FROM AA.ARR.ID.LST SETTING CAMP.TY.POS
        WHILE Y.ARR.ID:CAMP.TY.POS
            GOSUB ARR.CONDITION
            Y.CUSTOMER.CONDITION=R.CONDITION
            Y.CAMPAIGN.TYPE = Y.CUSTOMER.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TYPE>
            IF Y.CAMPAIGN.TYPE EQ CAMP.ENQ THEN
                Y.FINAL.ARRAY<-1> = Y.ARR.ID
            END

        REPEAT
    END ELSE
        Y.FINAL.ARRAY = AA.ARR.ID.LST
    END
RETURN
*----------------------------------------------------------------------
UPDATE.COM.VAR:
*--------------
    D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
    D.FIELDS<-1>=FIELDS.BK<POS1>

RETURN
*----------------------------------------------------------------------
ARR.CONDITION:
*-------------

    EFF.DATE = ''
    R.CONDITION = ''
    ERR.MSG = ''

    APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);*MANUAL R22 CODE CONVERSION
RETURN
*--------------------------------------------------------------------
GET.PRODUCT.DETAIL:
*------------------
    R.ARRANGEMENT=''
   * CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    R.ARRANGEMENT =  AA.Framework.Arrangement.Read(Y.ARR.ID, ARR.ERR)
RETURN
*----------------------------------------------------------------------
ASSIGN.VALUES:
*-------------
    Y.PARAM.ARRAY = ''
    Y.ARR.COUNT=DCOUNT(Y.FINAL.ARRAY,@FM)

    VAR1=1

    LOOP
    WHILE VAR1 LE Y.ARR.COUNT

        IF MOD(VAR1,25) EQ 0 THEN
            CALL OCOMO("Processed the ids - ":VAR1:"/":Y.ARR.COUNT)
        END

        Y.ARR.ID = Y.FINAL.ARRAY<VAR1>

        APAP.TAM.redoGetDisbursementDetails(Y.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB) ;*MANUAL R22 CODE CONVERSION
        GOSUB GET.PRODUCT.DETAIL
        GOSUB CHECK.DISB.DATE.SELECT.CRITERIA
        GOSUB CHECK.CANCELLED.LOAN
        IF Y.SKIP.LOAN EQ 'YES' THEN
            VAR1 += 1
            CONTINUE
        END

        LOAN.ORG.AGENCY      = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCoCode>          ;***************************************************** 1ST FIELD VALUE
        Y.PRODUCT            = R.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct>          ;*************************************************************** 2ND FIELD VALUE
        Y.PRODUCT.GROUP      = R.ARRANGEMENT<AA.Framework.Arrangement.ArrProductGroup>    ;***************************************************** 3RD FIELD VALUE

        PROP.CLASS            = 'CUSTOMER'
        PROPERTY              = ''

        GOSUB ARR.CONDITION

        Y.CUSTOMER.CONDITION  = R.CONDITION
        Y.CAMPAIGN.TYPE       = Y.CUSTOMER.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TYPE> ;*********************** 4TH FIELDS VALUE
        Y.AFF.COMPANY         = Y.CUSTOMER.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>   ;********************************* 5TH FIELDS VALUE

        Y.LOAN.NO             = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId>  ;*********************************************************************************** 6TH FIELD VALUE


        PROP.CLASS='ACCOUNT'
        PROPERTY = ''

        GOSUB ARR.CONDITION
        Y.ACCOUNT.CONDITION  = R.CONDITION

        Y.PRE.LOAN.NO        = Y.ACCOUNT.CONDITION<AA.AC.ALT.ID>      ;***************************************************** 7TH FIELD VALUE
        Y.PRI.OWNER          = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER> ;*Manual R22 conversion
        GOSUB CUST.DET        ;*********************************************************************************** 8TH FIELD VALUE
        GOSUB GET.REQ.NO      ;*********************************************************************************** 9TH FIELD VALUE
        IF R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrOrigContractDate> THEN
            Y.OPENING.DATE = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrOrigContractDate>
        END ELSE
            Y.OPENING.DATE = R.ARRANGEMENT< AA.Framework.ArrangementSim.ArrStartDate>         ;***************************************************** 10TH FIELD VALUE
        END

        PROP.CLASS='TERM.AMOUNT'
        PROPERTY = ''
        GOSUB ARR.CONDITION
        TERM.CONDITION=R.CONDITION
        Y.COMMIT.AMT=TERM.CONDITION<AA.AMT.AMOUNT>          ;***************************************************** 11TH FIELD VALUE

        GOSUB GET.ID.TYPE     ;*********************************************************************************** 12TH FIELD VALUE
        Y.ID.NUMBER=R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>:@VM:R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.RNC>:@VM:R.CUS<EB.CUS.LEGAL.ID>     ;************ 13TH FIELD VALUE

        GOSUB GET.DISB.DETAILS          ;************************************************************************* 15 &16TH FIELD VALUE

        GOSUB GET.INTEREST.RATE         ;************************************************************************* 18TH FIELD VALUE
        GOSUB ARR.ACCT.ALT.ID ;*********************************************************************************** 19TH FIELD VALUE
        Y.LOAN.EXP = TERM.CONDITION<AA.AMT.MATURITY.DATE>   ;***************************************************** 20TH FIELD VALUE

        GOSUB GET.COLLATERAL.DET        ;************************************************************************* 14TH & 22ND FIELD VALUE

*CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARR)

        Y.CURRENCY = R.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>         ;***************************************************** 24TH FIELD VALUE

        VAR1 += 1

        GOSUB FORM.ARRAY

    REPEAT

RETURN

*----------------------------------------------------------------------
CHECK.DISB.DATE.SELECT.CRITERIA:
*----------------------------------------------------------------------
* Here we will validate the selection criteria disbursement date

    Y.SKIP.LOAN = ''
    IF Y.VALUE ELSE ;* If no disb date criteria entered then skip
        RETURN
    END

    IF Y.OPERAND EQ 1 THEN
        IF Y.VALUE MATCHES R.DISB.DETAILS<1> ELSE
            Y.SKIP.LOAN = 'YES'
        END
    END
    IF Y.OPERAND EQ 2 THEN
        Y.DISBURSEMENT.DATES = R.DISB.DETAILS<1>
        Y.SKIP.LOAN = 'YES'
        LOOP        ;*Here we are looping cos loan may have multiple disb date
            REMOVE Y.DATE FROM Y.DISBURSEMENT.DATES SETTING DISB.POS
        WHILE Y.DATE:DISB.POS
            IF Y.DATE GE Y.VALUE<1,1> AND Y.DATE LE Y.VALUE<1,2> THEN
                Y.SKIP.LOAN = ''
            END

        REPEAT
    END

RETURN
*----------------------------------------------------------------------
GET.DISB.DETAILS:
*----------------

    Y.DISB.DATE       = R.DISB.DETAILS<1>         ;*********************** 15TH FIELD VALUE
    Y.DISB.AMOUNT     = R.DISB.DETAILS<2>         ;*********************** 16TH FIELD VALUE
    Y.DISB.REMAIN.AMT = Y.PEND.DISB     ;***************************************************** 17TH FIELD VALUE

RETURN
*----------------------------------------------------------------------
CUST.DET:
*--------
    CALL F.READ(FN.CUSTOMER,Y.PRI.OWNER,R.CUS,F.CUSTOMER,CUS.ERR)
    Y.CLIENT.NAME=R.CUS<EB.CUS.SHORT.NAME>        ;*************************************************************** 8TH FIELD VALUE
RETURN
*----------------------------------------------------------------------
GET.REQ.NO:
*----------
*IN.ARR.ID = ''
*CALL REDO.CONVERT.ACCOUNT(IN.ARR.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
*SEL.CMD  = 'SELECT ':FN.REDO.ISSUE.CLAIMS:' WITH ACCOUNT.ID EQ ':OUT.ID:' AND PRODUCT.TYPE EQ PRESTAMOS'
*CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.FINAL.SOL.IDS = ""
    Y.CU.CIDENT = R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
    CALL F.READ(FN.REDO.FC.CUST.SOLICITUD, Y.PRI.OWNER, R.CUST.SOLICITUD, F.REDO.FC.CUST.SOLICITUD, Y.ERR)
    IF R.CUST.SOLICITUD THEN
        Y.FINAL.SOL.IDS = R.CUST.SOLICITUD
    END
    CALL F.READ(FN.REDO.FC.CUST.SOLICITUD, Y.CU.CIDENT, R.CUST.SOLICITUD.CIDENT, F.REDO.FC.CUST.SOLICITUD, Y.ERR)
    IF R.CUST.SOLICITUD.CIDENT THEN
        Y.FINAL.SOL.IDS<-1> = R.CUST.SOLICITUD.CIDENT
    END
    CHANGE @FM TO @VM IN Y.FINAL.SOL.IDS
    Y.REQ.NO = Y.FINAL.SOL.IDS          ;*********************************************************************************** 9TH FIELD VALUE

RETURN
*----------------------------------------------------------------------
GET.ID.TYPE:
*-----------

    IF R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT> NE '' THEN
        Y.ID.TYPE='CEDULA'    ;*********************************************************************************** 12TH FIELD VALUE
        RETURN
    END
    IF R.CUS<EB.CUS.LEGAL.ID> NE '' THEN
        Y.ID.TYPE='PASAPORTE' ;*********************************************************************************** 12TH FIELD VALUE
        RETURN
    END
    IF R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.RNC> NE '' THEN
        Y.ID.TYPE='RNC'       ;*********************************************************************************** 12TH FIELD VALUE
        RETURN
    END
RETURN
*----------------------------------------------------------------------
GET.COLLATERAL.DET:
*------------------

    Y.GUAR.NO   = ''
    Y.GUAR.VAL  = ''
    Y.TYPE.OF.SECURITY = ''
    Y.COLLATERAL.NAME  = ''


    Y.GUAR.NO  = TERM.CONDITION<AA.AMT.LOCAL.REF,POS.L.AA.COL>        ;******************************************* 21ST FIELD VALUE
    Y.GUAR.VAL = TERM.CONDITION<AA.AMT.LOCAL.REF,POS.L.AA.COL.VAL>    ;********************************* 23RD FIELD VALUE
    CHANGE @SM TO @VM IN Y.GUAR.NO
    CHANGE @SM TO @VM IN Y.GUAR.VAL

    Y.GUAR.CNT = DCOUNT(Y.GUAR.NO,@VM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.GUAR.CNT
        Y.GUAR.ID = Y.GUAR.NO<1,Y.CNT1>
        CALL F.READ(FN.COLLATERAL,Y.GUAR.ID,R.COLLATERAL,F.COLLATERAL,CALL.ERR)
        Y.COLLATERAL.NAME<1,-1>  = R.COLLATERAL<COLL.LOCAL.REF,POS.L.COL.VALU.NAM>        ;********************************* 14TH FIELD VALUE
        Y.TYPE.OF.SECURITY<1,-1> = R.COLLATERAL<COLL.COLLATERAL.CODE> ;*COLLATERAL > TYPE.OF.SECURITY       ;*************** 22ND FIELD VALUE
        Y.CNT1 += 1
    REPEAT

RETURN
*----------------------------------------------------------------------
GET.INTEREST.RATE:
*----------------------------------------------------------------------

    Y.INTEREST.RATE   = ''
    PROP.NAME         = 'PRINCIPAL'
    PRINCIPALINT.PROP = ''
    APAP.TAM.redoGetInterestProperty(Y.ARR.ID,PROP.NAME,PRINCIPALINT.PROP,ERR);*MANUAL R22 CODE CONVERSION
    IF PRINCIPALINT.PROP ELSE
        RETURN
    END

    EFF.DATE     = ''
    PROP.CLASS   = 'INTEREST'
    PROPERTY     = PRINCIPALINT.PROP
    R.PRIN.CONDITION  = ''
    ERR.MSG      = ''
    APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.PRIN.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION

    Y.INTEREST.RATE = R.PRIN.CONDITION<AA.INT.EFFECTIVE.RATE,1>       ;***************************************************** 18TH FIELD VALUE

RETURN
*----------------------------------------------------------------------
ARR.ACCT.ALT.ID:
*---------------
    Y.TOTAL.CAP.BAL = ''
    APAP.TAM.redoGetTotalOutstandingSinUncUnd(Y.ARR.ID,Y.PROP.AMT,Y.TOTAL.AMT) ;*Manual R22 conversion
    Y.TOTAL.CAP.BAL = Y.PROP.AMT<1>

RETURN
*----------------------------------------------------------------------
ACCT.ACT.BK.BAL:
*---------------
    Y.TOTAL.CAP.BAL = 0
    Y.BALANCE.TO.CHECK.ARRAY = 'CURACCOUNT':@VM:'DUEACCOUNT':@VM:'GRCACCOUNT':@VM:'DELACCOUNT':@VM:'NABACCOUNT'
    LOOP
        REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
    WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
        DATE.OPTIONS = ''
        EFFECTIVE.DATE = TODAY
        DATE.OPTIONS<2> = 'ALL'
        BALANCE.AMOUNT = ""
*        CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
AA.Framework.GetPeriodBalances(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 UTILITY AUTO CONVERSION
        IF NOT(Y.TOTAL.CAP.BAL) THEN
            Y.TOTAL.CAP.BAL =  Y.TOTAL.CAP.BAL + BAL.DETAILS<IC.ACT.BALANCE>
        END ELSE
            Y.TOTAL.CAP.BAL = Y.TOTAL.CAP.BAL + BAL.DETAILS<IC.ACT.BALANCE>
        END
    REPEAT
RETURN

*--------------------------------------------
CHECK.OPERAND.COND:
*--------------------------------------------
* Here selection criteria is validated against the operand

    IF Y.OPERAND EQ 1 THEN
        Y.VALUE.CNT = DCOUNT(Y.VALUE,@SM)
        IF Y.VALUE.CNT GT 1 THEN
            ENQ.ERROR = "Only one value allowed for this operand - ":Y.FIELD
            GOSUB END1
        END
    END
    IF Y.OPERAND EQ 2 THEN
        Y.VALUE.CNT = DCOUNT(Y.VALUE,@SM)
        IF Y.VALUE.CNT NE 2 THEN
            ENQ.ERROR = "Two values needs to be entered for this operand - ":Y.FIELD
            GOSUB END1
        END
    END

RETURN
*----------------------------------------------------------------------
CHECK.CANCELLED.LOAN:
*----------------------------------------------------------------------
* we should not display the cancelled/paidoff loans in the report.

    Y.PRODUCT.GROUP.ID = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup>
    LOCATE Y.PRODUCT.GROUP.ID IN Y.PARAM.ARRAY<1,1> SETTING LOC.POS ELSE        ;* To avoild multiple read of same param record.
        CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP.ID,R.REDO.APAP.PROPERTY.PARAM,PARAM.ERR)
        Y.PARAM.ARRAY<1,-1> = Y.PRODUCT.GROUP.ID
        Y.PAYOFF.ACTIVITIES = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        CHANGE @VM TO @SM IN Y.PAYOFF.ACTIVITIES
        Y.PARAM.ARRAY<2,-1> = Y.PAYOFF.ACTIVITIES
    END
    LOCATE Y.PRODUCT.GROUP.ID IN Y.PARAM.ARRAY<1,1> SETTING POS.PARAM THEN
        Y.PAYOFF.ACTIVITY = Y.PARAM.ARRAY<2,POS.PARAM>
        Y.PAYOFF.ACTIVITY.CNT = DCOUNT(Y.PAYOFF.ACTIVITY,@SM)
    END
    *CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)
    R.AA.ACTIVITY.HISTORY=AA.Framework.ActivityHistory.Read(Y.ARR.ID, ACT.ERR)
    Y.ACTIVITY.HISTORY        = R.AA.ACTIVITY.HISTORY< AA.Framework.ActivityHistoryHist.AhActivity>
    Y.ACTIVITY.STATUS.HISTORY = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActStatus>
    CHANGE @SM TO @FM IN Y.ACTIVITY.HISTORY
    CHANGE @VM TO @FM IN Y.ACTIVITY.HISTORY
    CHANGE @SM TO @FM IN Y.ACTIVITY.STATUS.HISTORY
    CHANGE @VM TO @FM IN Y.ACTIVITY.STATUS.HISTORY

    Y.PAYOFF.POS = 1
    LOOP
    WHILE Y.PAYOFF.POS LE Y.PAYOFF.ACTIVITY.CNT
        Y.CANCEL.ACTIVITY = Y.PAYOFF.ACTIVITY<1,1,Y.PAYOFF.POS>
        LOCATE Y.CANCEL.ACTIVITY IN Y.ACTIVITY.HISTORY<1> SETTING POS.ACT THEN  ;* Here we are checking whether loan has payoff activity in auth stage. we are locating once cos the latest applypayment-rp.payoff is in AUTH stage(During payoff cheque reversal, we wont trigger applypayment-rp.payoff, So we can presume that applypayment-rp.payoff is in AUTH stage then loan is cancelled).

            IF Y.ACTIVITY.STATUS.HISTORY<POS.ACT> EQ 'AUTH' THEN
                Y.SKIP.LOAN = 'YES'
            END
        END

        Y.PAYOFF.POS += 1
    REPEAT

RETURN
*----------------------------------------------------------------------
FORM.ARRAY:
*----------

*VALUE NO :                 1                2                3                   4                 5               6                7               8

    Y.ENQ.OUT<-1> = LOAN.ORG.AGENCY:"*":Y.PRODUCT:"*":Y.PRODUCT.GROUP:"*":Y.CAMPAIGN.TYPE:"*":Y.AFF.COMPANY:"*":Y.LOAN.NO:"*":Y.PRE.LOAN.NO:"*":Y.CLIENT.NAME


*VALUE NO :                 9             10             11              12              13               14                  15             16              17

    Y.ENQ.OUT := "*":Y.REQ.NO:"*":Y.OPENING.DATE:"*":Y.CURRENCY:"*":Y.COMMIT.AMT:"*":Y.ID.TYPE:"*":Y.ID.NUMBER:"*":Y.COLLATERAL.NAME:"*":Y.DISB.DATE:"*":Y.DISB.AMOUNT


*VALUE NO :                   18                  19                20                21             22                23                 24

    Y.ENQ.OUT := "*":Y.DISB.REMAIN.AMT:"*":Y.INTEREST.RATE:"*":Y.TOTAL.CAP.BAL:"*":Y.LOAN.EXP:"*":Y.GUAR.NO:"*":Y.TYPE.OF.SECURITY:"*":Y.GUAR.VAL


RETURN
*----------------------------------------------------------------------
END1:
END
