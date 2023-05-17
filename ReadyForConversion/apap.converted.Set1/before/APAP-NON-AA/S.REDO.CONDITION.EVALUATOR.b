*-----------------------------------------------------------------------------
* <Rating>-76</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CONDITION.EVALUATOR(R.COND.DEF, P.VALUES, P.RETURN)
*-----------------------------------------------------------------------------
* Condition Evaluator
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package tam.redo
*
* This allows to evaluate a condition, according the passed values, please see the following example
*
*    R.COND.DEF<1,1> =  "CATEGORY"
*    R.COND.DEF<1,2> =  "CUS.RELATION.CODE"
*    R.COND.DEF<2,1> =  "RG"
*    R.COND.DEF<2,2> =  "EQ"
*    R.COND.DEF<3,1> =  "3101"
*    R.COND.DEF<4,1> =  "3102"
*    R.COND.DEF<3,2> =  "305"
*    R.COND.DEF<4,2> =  ""
*    R.COND.DEF<5,1> =  "AND"
*    R.COND.DEF<5,2> =  ""
*    P.VALUES<1,1> = "CATEGORY"
*    P.VALUES<1,2> = "CUS.RELATION.CODE"
*    P.VALUES<2,1> = 3101
*    P.VALUES<2,2,1> = 303
*    P.VALUES<2,2,2> = 301            ;* This customer has two relation code to evaluate
*
*    In this case the routine must return false
*
*  Parameters:
*
*              R.COND.DEF   (in) Definition to evaluate, fields separated by FM
*                                           1. Name of the fields to evaluate
*                                           2. Operand according to passed fields
*                                           3. MIN values
*                                           4. MAX values
*                                           5. Logic operand in case of more than one fields in position 1
*              P.VALUES             (in)    Values of the variables to be evaluated
*   Output:
*              P.RETURN             (out)    @TRUE, if the expression was evaluated as true, else @FALSE
*              E                    (out)    Message-Code in case of error
*
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE


*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  IF Y.MUST.CONTINUE THEN
    GOSUB PROCESS
  END
  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* DEBUG
  Y.TOTAL.CONDITIONS = DCOUNT(R.COND.DEF<K.FIELD.NO>, VM)

  P.RETURN = @FALSE

  FOR Y.POS = 1 TO Y.TOTAL.CONDITIONS
    Y.VAR.DEF = R.COND.DEF<K.FIELD.NO,Y.POS>
    LOCATE Y.VAR.DEF IN P.VALUES<1,1> SETTING Y.VM ELSE
*            E = "ST-REDO.CCRG.EVAL.VAR.NON.EXISTS" : VM : "VARIABLE & NOT FOUND, WHEN CONDITION WAS EVALUATED"
*            E<2> = Y.VAR.DEF
*            RETURN
      CALL OCOMO("VARIABLE [" : Y.VAR.DEF : "] NOT PASSED, BLANK VALUE ASSIGNED ")
    END


    GOSUB EVALUATE.CURRENT.CONDITION

    IF Y.POS GT 1 AND R.COND.DEF<K.BOOL.OPE,Y.POS-1> EQ 'AND' THEN
      P.RETURN = (P.RETURN AND Y.CUR.EVAL.RES)
    END ELSE
      IF Y.POS GT 1 AND R.COND.DEF<K.BOOL.OPE,Y.POS-1> EQ 'OR' THEN
        P.RETURN = (P.RETURN OR Y.CUR.EVAL.RES)
      END ELSE
        P.RETURN = Y.CUR.EVAL.RES
      END
    END

    IF E THEN
      RETURN
    END

  NEXT Y.POS

  RETURN

*-----------------------------------------------------------------------------
EVALUATE.CURRENT.CONDITION:
* Compare each value.
*-----------------------------------------------------------------------------

  Y.CUR.EVAL.RES = @FALSE
  Y.VALUE.LIST = P.VALUES<2,Y.VM>
  Y.TOT.VALUES = DCOUNT(Y.VALUE.LIST,SM)
  E = ''


  FOR Y.VAL.POS = 1 TO Y.TOT.VALUES
    Y.VALUE = Y.VALUE.LIST<1,1,Y.VAL.POS>
    GOSUB EVALUATE.VALUE
    Y.CUR.EVAL.RES = Y.VAL.RETURN
    IF Y.CUR.EVAL.RES OR E THEN
      BREAK         ;* At least one value was evaluated as @TRUE, then leave proces
    END
  NEXT Y.VAL.POS

  RETURN

*-----------------------------------------------------------------------------
EVALUATE.VALUE:
* Compare Y.VALUE with current condition
*-----------------------------------------------------------------------------

  Y.VAL.RETURN = @FALSE
  BEGIN CASE

  CASE R.COND.DEF<K.OPERAND,Y.POS> EQ "EQ"
    Y.VAL.RETURN = (Y.VALUE EQ R.COND.DEF<K.MIN.VAL,Y.POS>)
  CASE R.COND.DEF<K.OPERAND,Y.POS> EQ "NE"
    Y.VAL.RETURN = (Y.VALUE NE R.COND.DEF<K.MIN.VAL,Y.POS>)
  CASE R.COND.DEF<K.OPERAND,Y.POS> EQ "RG"
    Y.VAL.RETURN = (Y.VALUE GE R.COND.DEF<K.MIN.VAL,Y.POS> AND Y.VALUE LE R.COND.DEF<K.MAX.VAL,Y.POS>)
  CASE R.COND.DEF<K.OPERAND,Y.POS> EQ "NR"
    Y.VAL.RETURN = NOT(Y.VALUE GE R.COND.DEF<K.MIN.VAL,Y.POS> AND Y.VALUE LE R.COND.DEF<K.MAX.VAL,Y.POS>)
  CASE 1
    E = "ST-REDO.CCRG.OP.NOT.IMPLEMENTED" : VM : "OPERAND & WAS NOT IMPLEMENTED"
    E<2> = R.COND.DEF<K.OPERAND,Y.POS>
  END CASE
  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  Y.MUST.CONTINUE = 1

  IF R.COND.DEF EQ '' THEN
    CALL OCOMO("THERE IS NOT CONDITION TO EVALUATE")
    E = "ST-REDO.CCRG.PARAMETER.IS.EMPTY"
    E<2> = "R.COND.DEF" : VM : "S.REDO.CONDITION.EVALUATOR"
    Y.MUST.CONTINUE = 0
    RETURN
  END

  IF P.VALUES EQ '' THEN
    CALL OCOMO("VARIABLE VALUES IS EMPTY")
    E = "ST-REDO.CCRG.PARAMETER.IS.EMPTY"
    E<2> = "P.VALUES" : VM : "S.REDO.CONDITION.EVALUATOR"
    Y.MUST.CONTINUE = 0
    RETURN
  END

* Expected Positions
  K.FIELD.NO = 1
  K.OPERAND  = 2
  K.MIN.VAL  = 3
  K.MAX.VAL  = 4
  K.BOOL.OPE = 5


  RETURN
*-----------------------------------------------------------------------------
END
