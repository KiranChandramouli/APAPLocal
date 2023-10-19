* @ValidationCode : Mjo4NzQ5MzgwMzg6Q3AxMjUyOjE2ODI2MDE4NTY5NTc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 18:54:16
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.FHA.INSURANCE.REPORT.COPY(Y.FINAL.ARRAY)

*-----------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Sakthi Sellappillai
*Program Name      : REDO.NOF.FHA.INSURANCE.REPORT
*Developed for     : ODR-2010-03-0085
*Date              : 19.08.2010
*-----------------------------------------------------------------------------------------------------------
*Description:This is No File Enquiry routine.This will select the live file REDO.T.AUTH.ARRANGEMENT records,
* and fetch the values from the selected ARRANGEMENT records for ENQUIRY.REPORT-REDO.FHA.INSURANCE.REPORT
*-----------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------------------------------------
* Dependencies:
*-------------
* Linked with : NOFILE.REDO.FHA.INSURANCE.REPORT - Standard Selection of REDO.ENQ.FHA.INSURANCE.REP(ENQUIRY)
* Calls       : AA.GET.ARRANGEMENT.CONDITIONS,AA.GET.PERIOD.BALANCES
* Called By   : --N/A--
*-----------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name                         Reference                    Version
* -------           ----                         ----------                   --------
* 19.08.2010       Sakthi Sellappillai           ODR-2010-03-0085             Initial Version
*
* 13-APR-2023     Conversion tool   R22 Auto conversion               FM TO @FM, VM to @VM, ++ to +=
* 13-APR-2023      Harishvikram C   Manual R22 conversion             CALL method format changed
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $USING APAP.TAM

    GOSUB OPEN.FILES
    GOSUB GET.SELECTION.VALUES
    GOSUB PROCESS
RETURN
*-------------------------------------
OPEN.FILES:
*-------------------------------------

    Y.FINAL.ARRAY = ''
    Y.MG.WITH.FHA.COUNT = 0
    Y.SEL.ORIGIN.AGENCY = ''

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS  = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-------------------------------------
GET.SELECTION.VALUES:
*-------------------------------------

    VALUE.BK   = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK  = D.FIELDS

    D.RANGE.AND.VALUE  = ''
    D.LOGICAL.OPERANDS = ''
    D.FIELDS           = ''

    LOCATE 'LOAN.PRODUCT' IN FIELDS.BK SETTING FLD.POS THEN
        Y.PRODUCT = VALUE.BK<FLD.POS>
        IF Y.PRODUCT NE 'HIPOTECARIO' THEN
            ENQ.ERROR = 'EB-ONLY.MG.LOAN'
            GOSUB END1
        END
    END
    LOCATE 'ORIGIN.AGENCY' IN FIELDS.BK SETTING FLD.POS THEN
        Y.SEL.ORIGIN.AGENCY = VALUE.BK<FLD.POS>
    END

    FIELDS.ARRAY = 'POL.EXP.DATE':@FM:'POL.START.DATE':@FM:'FEC.SOL.RESGUAR'

    FIELDS.CNT = DCOUNT(FIELDS.ARRAY,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE FIELDS.CNT
        Y.FIELD = FIELDS.ARRAY<Y.VAR1>
        LOCATE Y.FIELD IN FIELDS.BK SETTING FLD.POS THEN
            D.RANGE.AND.VALUE<-1>  =  VALUE.BK<FLD.POS>
            D.LOGICAL.OPERANDS<-1> =  OPERAND.BK<FLD.POS>
            D.FIELDS<-1>           =  FIELDS.BK<FLD.POS>
        END
        Y.VAR1 += 1
    REPEAT
    CALL APAP.REDOENQ.RedoEFormSelStmt(FN.APAP.H.INSURANCE.DETAILS, '', '', SEL.CMD);* R22 Manual Conversion - CALL method format changed
    SEL.CMD:= ' WITH INS.POLICY.TYPE EQ FHA'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    SEL.CMD.NEW = 'SELECT ':FN.APAP.H.INSURANCE.DETAILS:' WITH INS.POLICY.TYPE EQ FHA'
    CALL EB.READLIST(SEL.CMD.NEW,SEL.LIST.NEW,'',NO.OF.REC.NEW,SEL.ERR)
RETURN
*-------------------------------------
PROCESS:
*-------------------------------------

    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE NO.OF.REC.NEW
        Y.INS.ID = SEL.LIST.NEW<Y.VAR2>
        R.APAP.H.INSURANCE.DETAILS = ''
        CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,Y.INS.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,INS.ERR)
        IF R.APAP.H.INSURANCE.DETAILS THEN
            Y.LOAN.NOS = R.APAP.H.INSURANCE.DETAILS<INS.DET.ASSOCIATED.LOAN>
            GOSUB PROCESS.LOANS
        END
        Y.VAR2 += 1
    REPEAT
    GOSUB FINAL.STRING.FORM
RETURN
*------------------------------------
FINAL.STRING.FORM:
*------------------------------------

    Y.AA.ARRANGE.SEL.CMD ="SELECT ": FN.AA.ARRANGEMENT:" WITH PRODUCT.GROUP EQ HIPOTECARIO"
    CALL EB.READLIST(Y.AA.ARRANGE.SEL.CMD,Y.TOT.AA.SEL.LIST,'',Y.NO.OF.MG.ARRANGE,Y.TOT.AA.SEL.ERR)
    Y.TOTAL.AA.PROD.MG      = Y.NO.OF.MG.ARRANGE
    Y.MG.WITHOUT.FHA.COUNT  = Y.TOTAL.AA.PROD.MG - Y.MG.WITH.FHA.COUNT
    Y.MORT.WITH.FHA.PERC    = (Y.MG.WITH.FHA.COUNT / Y.TOTAL.AA.PROD.MG) * 100
    Y.MORT.WITHOUT.FHA.PERC = (Y.MG.WITHOUT.FHA.COUNT / Y.TOTAL.AA.PROD.MG) * 100
    Y.FINAL.CNT = DCOUNT(Y.FINAL.ARRAY,@FM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.FINAL.CNT
        Y.FINAL.ARRAY<Y.CNT1> := "*":Y.MG.WITH.FHA.COUNT:"*":Y.MG.WITHOUT.FHA.COUNT:"*":Y.MORT.WITH.FHA.PERC:"*":Y.MORT.WITHOUT.FHA.PERC
        Y.CNT1 += 1
    REPEAT

RETURN
*-------------------------------------
PROCESS.LOANS:
*-------------------------------------
    Y.NO.OF.LOANS = DCOUNT(Y.LOAN.NOS,@VM)
    Y.VAR3 = 1
    LOOP
    WHILE Y.VAR3 LE Y.NO.OF.LOANS
        Y.AA.ID = Y.LOAN.NOS<1,Y.VAR3>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
        IF R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'HIPOTECARIO' THEN
            LOCATE Y.INS.ID IN SEL.LIST SETTING APP.POS THEN
                IF Y.SEL.ORIGIN.AGENCY NE '' THEN
                    IF Y.SEL.ORIGIN.AGENCY EQ R.AA.ARRANGEMENT<AA.ARR.CO.CODE> THEN
                        GOSUB GET.DETAILS
                    END
                END ELSE
                    GOSUB GET.DETAILS
                END
            END
            Y.MG.WITH.FHA.COUNT += 1
        END
        Y.VAR3 += 1
    REPEAT

RETURN
*-------------------------------------
GET.DETAILS:
*-------------------------------------
    Y.CUS.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    IN.ACC.ID = ''
    OUT.ID = ''
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.AA.ID,OUT.ID,ERR.TEXT);* R22 Manual Conversion - CALL method format changed
    GOSUB GET.PREVIOUS.LOAN.NO
    GOSUB GET.CUSTOMER.DETAILS
    Y.CLOSING.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>
    Y.DISB.AMT = 0
    CALL APAP.TAM.redoGetDisbursedAmt(Y.AA.ID,Y.DISB.AMT) ;* R22 Manual Conversion - CALL method format changed
    Y.INSURED.AMOUNT = SUM(R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>)
    Y.CUSTODAY.DATE  = R.APAP.H.INSURANCE.DETAILS<INS.DET.FEC.SOL.RESGUAR>
    Y.CASE.NUMBER    = R.APAP.H.INSURANCE.DETAILS<INS.DET.FHA.CASE.NO>
    CALL APAP.TAM.redoGetTotalOutstanding(Y.AA.ID,Y.PROP.AMT,Y.TOTAL.AMT) ;* R22 Manual Conversion - CALL method format changed
    Y.TOTAL.CAPITAL.BAL =  Y.PROP.AMT<1>
    GOSUB FORM.ARRAY
RETURN
*-------------------------------------
GET.PREVIOUS.LOAN.NO:
*-------------------------------------
    EFF.DATE        = ''
    PROP.CLASS      = 'ACCOUNT'
    PROPERTY        = ''
    R.ACC.CONDITION = ''
    ERR.MSG         = ''
    CALL APAP.TAM.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.ACC.CONDITION,ERR.MSG);* R22 Manual conversion - CALL method format changed
    Y.PREV.LOAN.NO = R.ACC.CONDITION<AA.AC.ALT.ID>

RETURN
*-------------------------------------
GET.CUSTOMER.DETAILS:
*-------------------------------------
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.CUSTOMER.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>

RETURN
*-------------------------------------
FORM.ARRAY:
*-------------------------------------
    Y.FINAL.ARRAY<-1> = OUT.ID:'*':Y.PREV.LOAN.NO:'*':R.AA.ARRANGEMENT<AA.ARR.CO.CODE>:'*':Y.CUSTOMER.NAME:'*':Y.CLOSING.DATE:'*':Y.DISB.AMT:'*':Y.INSURED.AMOUNT:'*':Y.CUSTODAY.DATE:'*':Y.CASE.NUMBER:'*':Y.TOTAL.CAPITAL.BAL
RETURN
*-------------------------------------
END1:
END
