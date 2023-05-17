*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.EVAL.BAL.TYP.CON(R.RCBTP, P.VALUES, P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*             This routine allows to evaluate condition gotten from REDO.CCRG.BALANCE.TYPE.PARAM
*   and calls to S.REDO.CONDITION.EVALUATOR
*   Example:
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.BALANCE.TYPE,1> = "SECURED"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.BALANCE.TYPE,1> = "UNSECURED"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.FIELD.NO,X,1> = "CATEGORY"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.FIELD.NO,X,2> = "CUS.RELATION.CODE"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.OPERATOR,X,1> = "RG"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.OPERATOR,X,2> = "EQ"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.MIN.VALUE,X,1> = "3001"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.MIN.VALUE,X,2> = "305"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.MAX.VALUE,X,1> = "3002"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.MAX.VALUE,X,2> = ""
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.BOOL.OPER,X,1> = "AND"
*            R.BAL.TYP.PARAM<REDO.CCRG.BTP.BOOL.OPER,X,2> = ""
*            P.VALUES<1,1> = "CATEGORY"
*            P.VALUES<1,2> = "CUS.RELATION.CODE"
*            P.VALUES<2,1> = 3101
*            P.VALUES<2,2,1> = 303
*            P.VALUES<2,2,2> = 303
*         For this example, the routine must return @FALSE
*
* Linked With:
*              REDO.CCRG.B.EXT Service
*
* In Parameter:
* ---------------
*           R.RCBTP              (in)  Record from REDO.CCRG.BALANCE.TYPE.PARAM
*           P.VALUES             (in)  Field.name>value assocations.
*                                      1 List of FIELD.NAME to evaluate
*                                      2 Values assigned to FIELD.NAME to evaluate
*
* Out Parameter:
* ---------------
*           P.RETURN             (out) Return the list of "Balance Types" applicable to current values
*           E (i_common)               User message in case of error
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 06/04/2011 - ODR-2011-03-0154
*              First version. Risk Limit for Customer and Group Risk
*              hpasquel@temenos.com
*--------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.CCRG.CONSTANT.COMMON
$INSERT I_F.REDO.CCRG.BALANCE.TYPE.PARAM

*
*--------------------------------------------------------------------------------------------
*


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

*
  RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
  P.RETURN = ''
  Y.TOT.BT = DCOUNT(R.RCBTP<REDO.CCRG.BTP.BALANCE.TYPE>,VM)
*
* Evaluate each of the Balance Type
*
  FOR Y.BT.POS = 1 TO Y.TOT.BT
    Y.CUR.BT = R.RCBTP<REDO.CCRG.BTP.BALANCE.TYPE, Y.BT.POS>
    R.COND.DEF = ''
    P.TRUE = @FALSE
    R.COND.DEF<1> = RAISE(R.RCBTP<REDO.CCRG.BTP.FIELD.NO, Y.BT.POS>)
    R.COND.DEF<2> = RAISE(R.RCBTP<REDO.CCRG.BTP.OPERATOR, Y.BT.POS>)
    R.COND.DEF<3> = RAISE(R.RCBTP<REDO.CCRG.BTP.MIN.VALUE, Y.BT.POS>)
    R.COND.DEF<4> = RAISE(R.RCBTP<REDO.CCRG.BTP.MAX.VALUE, Y.BT.POS>)
    R.COND.DEF<5> = RAISE(R.RCBTP<REDO.CCRG.BTP.BOOL.OPER, Y.BT.POS>)
    E = ''

    CALL S.REDO.CONDITION.EVALUATOR(R.COND.DEF, P.VALUES, P.TRUE)
*
* Check if an error occured
*
    IF E THEN
      RETURN
    END
*
* If the expression was evaluated as TRUE, then to add the BALANCE.TYPE to the result list
*
    IF P.TRUE THEN
      P.RETURN<1,-1> = Y.CUR.BT
    END
  NEXT Y.BT.POS

  RETURN


*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------

  RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

  LOOP.CNT         = 1
  MAX.LOOPS        = 2
  PROCESS.GOAHEAD  = 1

  RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------


  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
      IF R.RCBTP EQ "" THEN
        E = K.PARAMETER.IS.EMPTY : FM : "R.RCBTP" : VM : "S.REDO.CCRG.EVAL.BAL.TYP.CON"
        PROCESS.GOAHEAD = @FALSE
      END

    CASE LOOP.CNT EQ 2
      IF P.VALUES EQ "" THEN
        E = K.PARAMETER.IS.EMPTY : FM : "P.VALUES" : VM : "S.REDO.CCRG.EVAL.BAL.TYP.CON"
        PROCESS.GOAHEAD = @FALSE
      END

    END CASE

    LOOP.CNT +=1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------

END
