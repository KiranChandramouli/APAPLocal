*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.SC.EVALUATOR(P.IN.CONTRACT.ID, R.IN.RCBTP, R.IN.CUSTOMER, R.IN.SAM, P.OUT.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
*** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------
*  This routine decides if the REDO.CCRG.BALANCE.TYPE.PARAM contract must or not to be processed.
*  The contract must be of FOREX application
*
*  Input Param:
*  ------------
*     P.IN.CONTRACT.ID: Contract Id
*     R.IN.RCBTP: REDO.BALANCE.TYPE.PARAM record
*     R.IN.CUSTOMER: CUSTOMER record
*     R.IN.SAM: FOREX record. If this record is empty needs to be read
*
*  Output Param:
*  ------------
*     P.OUT.RETURN: Returns the types of balances that have to be calculated
*     E: Error message if exists
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.CUSTOMER
$INSERT I_F.SEC.ACC.MASTER
*
$INSERT I_REDO.CCRG.CONSTANT.COMMON
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN

*--------------------------------------------------
INITIALISE:
*--------------------------------------------------

  PROCESS.GOAHEAD = 1
  P.OUT.RETURN<1> = ''
  E               = ''
  Y.ERR           = ''
  P.VALUES        = ''

  RETURN



*--------------------------------------------------
OPEN.FILES:
*--------------------------------------------------

* Open files only if not already open

  FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
  F.SEC.ACC.MASTER = ''
  CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

*
  RETURN


*--------------------------------------------------
PROCESS:
*--------------------------------------------------

*Category Code
  P.VALUES<1,2> = K.CATEGORY
  P.VALUES<2,2> = R.IN.SAM<SC.SAM.CATEGORY>

* Call S.REDO.EVAL.BAL.TYPE.CON routine to evaluate the contract
  P.RESULT = ''
  CALL S.REDO.CCRG.EVAL.BAL.TYP.CON(R.IN.RCBTP, P.VALUES, P.RESULT)

* Get result process
  P.OUT.RETURN<1> = P.RESULT<1>
  P.OUT.RETURN<5> = R.IN.SAM<SC.SAM.CATEGORY>

  RETURN


*--------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------

*Get only the PORTFOLIO id
  Y.PORTFOLIO.ID = FIELD(P.IN.CONTRACT.ID,'.',1,1)

* Read record to Y.PORTFOLIO.ID
  R.SEC.ACC.MASTER = ''
  YERR = ''
  CALL F.READ(FN.SEC.ACC.MASTER,Y.PORTFOLIO.ID,R.IN.SAM,F.SEC.ACC.MASTER,YERR)

* Assign the error if exists
  E = Y.ERR
  IF NOT(R.IN.SAM) THEN
    PROCESS.GOAHEAD = 0
  END


  RETURN
*--------------------------------------------------
END
