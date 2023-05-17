SUBROUTINE S.REDO.CCRG.MM.EVALUATOR(P.IN.CONTRACT.ID, R.IN.RCBTP, R.IN.CUSTOMER, R.IN.MM, P.OUT.RETURN)
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
*  This routine decide if the REDO.CCRG.BALANCE.TYPE.PARAM contract must or not to be processed.
*  The contract must be the MM.MONEY.MARKET application
*
*  Input Param:
*  ------------
*     P.IN.CONTRACT.ID: Arrangement Id associated to LIMIT
*     R.IN.RCBTP: REDO.BALANCE.TYPE.PARAM record
*     R.IN.CUSTOMER: CUSTOMER record
*     R.IN.MM: Arrangement record. If this record is empty needs to be read
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
    $INSERT I_F.MM.MONEY.MARKET
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
*** Open the files
OPEN.FILES:

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)


RETURN
*** </region>

*** <region name= PROCESS>
*** Process the routine
PROCESS:
    P.VALUES<1,1> = K.CUS.RELATION.CODE
    Y.REL.CODE = CHANGE(R.IN.CUSTOMER<EB.CUS.RELATION.CODE>,@VM,@SM)
    P.VALUES<2,1> = Y.REL.CODE
    P.VALUES<1,2> = K.CATEGORY
    P.VALUES<2,2> = R.IN.MM<MM.CATEGORY>

* Call S.REDO.CONDITION.EVALUATOR routine
    P.RESULT = ''
    CALL S.REDO.CCRG.EVAL.BAL.TYP.CON(R.IN.RCBTP, P.VALUES, P.RESULT)
    P.OUT.RETURN<1> = P.RESULT<1>
    P.OUT.RETURN<5> = R.IN.MM<MM.CATEGORY>

RETURN
*** </region>


*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
*** Verify conditions
CHECK.PRELIM.CONDITIONS:

* Read de MM.MONEY.MARKET record with id
    CALL F.READ(FN.MM.MONEY.MARKET,P.IN.CONTRACT.ID,R.IN.MM,F.MM.MONEY.MARKET,Y.ERR)

    E = Y.ERR
    IF NOT(R.IN.MM) THEN
        PROCESS.GOAHEAD = 0
    END

RETURN
*** </region>
END
