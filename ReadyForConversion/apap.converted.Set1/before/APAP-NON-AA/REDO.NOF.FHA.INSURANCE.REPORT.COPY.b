*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
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

  FIELDS.ARRAY = 'POL.EXP.DATE':FM:'POL.START.DATE':FM:'FEC.SOL.RESGUAR'

  FIELDS.CNT = DCOUNT(FIELDS.ARRAY,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE FIELDS.CNT
    Y.FIELD = FIELDS.ARRAY<Y.VAR1>
    LOCATE Y.FIELD IN FIELDS.BK SETTING FLD.POS THEN
      D.RANGE.AND.VALUE<-1>  =  VALUE.BK<FLD.POS>
      D.LOGICAL.OPERANDS<-1> =  OPERAND.BK<FLD.POS>
      D.FIELDS<-1>           =  FIELDS.BK<FLD.POS>
    END
    Y.VAR1++
  REPEAT
  CALL REDO.E.FORM.SEL.STMT(FN.APAP.H.INSURANCE.DETAILS, '', '', SEL.CMD)
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
    Y.VAR2++
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
  Y.FINAL.CNT = DCOUNT(Y.FINAL.ARRAY,FM)
  Y.CNT1 = 1
  LOOP
  WHILE Y.CNT1 LE Y.FINAL.CNT
    Y.FINAL.ARRAY<Y.CNT1> := "*":Y.MG.WITH.FHA.COUNT:"*":Y.MG.WITHOUT.FHA.COUNT:"*":Y.MORT.WITH.FHA.PERC:"*":Y.MORT.WITHOUT.FHA.PERC
    Y.CNT1++
  REPEAT

  RETURN
*-------------------------------------
PROCESS.LOANS:
*-------------------------------------
  Y.NO.OF.LOANS = DCOUNT(Y.LOAN.NOS,VM)
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
      Y.MG.WITH.FHA.COUNT++
    END
    Y.VAR3++
  REPEAT

  RETURN
*-------------------------------------
GET.DETAILS:
*-------------------------------------
  Y.CUS.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
  IN.ACC.ID = ''
  OUT.ID = ''
  CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,OUT.ID,ERR.TEXT)
  GOSUB GET.PREVIOUS.LOAN.NO
  GOSUB GET.CUSTOMER.DETAILS
  Y.CLOSING.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>
  Y.DISB.AMT = 0
  CALL REDO.GET.DISBURSED.AMT(Y.AA.ID,Y.DISB.AMT)
  Y.INSURED.AMOUNT = SUM(R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>)
  Y.CUSTODAY.DATE  = R.APAP.H.INSURANCE.DETAILS<INS.DET.FEC.SOL.RESGUAR>
  Y.CASE.NUMBER    = R.APAP.H.INSURANCE.DETAILS<INS.DET.FHA.CASE.NO>
  CALL REDO.GET.TOTAL.OUTSTANDING(Y.AA.ID,Y.PROP.AMT,Y.TOTAL.AMT)
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
  CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.ACC.CONDITION,ERR.MSG)
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
