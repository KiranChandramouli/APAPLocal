*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.FX.EVALUATOR(P.IN.CONTRACT.ID, R.IN.RCBTP, R.IN.CUSTOMER, R.IN.FX, P.OUT.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
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
*     R.IN.FX: FOREX record. If this record is empty needs to be read
*
*  Output Param:
*  ------------
*     P.OUT.RETURN: Returns the types of balances that have to be calculated
*     E: Error message if exists
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.FOREX

$INSERT I_REDO.CCRG.CONSTANT.COMMON
$INSERT I_REDO.CCRG.B.EXT.COMMON
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN

*** <region name= INITIALISE>
*** <desc>Initialise the variables</desc>
****
INITIALISE:
  PROCESS.GOAHEAD = 1
  P.OUT.RETURN<1> = ''
  E               = ''
  Y.ERR           = ''
  P.VALUES        = ''

  RETURN
*** </region>

*** <region name= OPEN.FILES>
***
OPEN.FILES:
* Open files only if not already open
  FN.FOREX = 'F.FOREX'
  F.FOREX  = ''
  CALL OPF(FN.FOREX,F.FOREX)
*
  RETURN
*** </region>

*** <region name= PROCESS>
***
PROCESS:

*Relation Code for the customer
  P.VALUES<1,1> = K.CUS.RELATION.CODE
  Y.REL.CODE    = CHANGE(R.IN.CUSTOMER<EB.CUS.RELATION.CODE>,VM,SM)
  P.VALUES<2,1> = Y.REL.CODE

*Category Code
  P.VALUES<1,2> = K.CATEGORY
  P.VALUES<2,2> = R.IN.FX<FX.CATEGORY.CODE>

* Call S.REDO.EVAL.BAL.TYPE.CON routine
  P.RESULT = ''
  CALL S.REDO.CCRG.EVAL.BAL.TYP.CON(R.IN.RCBTP, P.VALUES, P.RESULT)

* Get result process
  P.OUT.RETURN<1> = P.RESULT<1>
  P.OUT.RETURN<5> = R.IN.FX<FX.CATEGORY.CODE>
  RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
***
CHECK.PRELIM.CONDITIONS:

* Read record with id P.IN.CONTRACT.ID
  R.IN.FX = ''
  CALL F.READ(FN.FOREX,P.IN.CONTRACT.ID,R.IN.FX,F.FOREX,Y.ERR)

* Assign the error if exists
  IF NOT(R.IN.FX) THEN
    E = 'ST-REDO.CCRG.RECORD.NOT.FOUND' : FM : P.IN.CONTRACT.ID : VM : FN.FOREX
    PROCESS.GOAHEAD = 0
  END

  RETURN
*** </region>
END
