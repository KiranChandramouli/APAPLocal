*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RNC.CHECK.DIGIT(Y.CHECK.DIGIT)
****************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : GANESH(ganeshr@temenos.com)
*Date              : 3.6.2010
*Program   Name    : REDO.RNC.CHECK.DIGIT
*---------------------------------------------------------------------------------------
*Description       : This routine is to verify the check digit of the input number
*Linked With       : REDO.V.VAL.RNC
*In  Parameter     : Y.CHECK.DIGIT
*Out Parameter     : Y.CHECK.DIGIT
*---------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:
  VAL.CHECK = Y.CHECK.DIGIT[9,1]
  Y.INPUT.NUM = Y.CHECK.DIGIT[1,8]
  RETURN

PROCESS:
  VAR.FIRST.DIGIT = Y.INPUT.NUM[1,1] * 7
  VAR.SECOND.DIGIT = Y.INPUT.NUM[2,1] * 9
  VAR.THIRD.DIGIT = Y.INPUT.NUM[3,1] * 8
  VAR.FOURTH.DIGIT = Y.INPUT.NUM[4,1] * 6
  VAR.FIFITH.DIGIT = Y.INPUT.NUM[5,1] * 5
  VAR.SIXTH.DIGIT = Y.INPUT.NUM[6,1] * 4
  VAR.SEVENTH.DIGIT = Y.INPUT.NUM[7,1] * 3
  VAR.EIGHT.DIGIT = Y.INPUT.NUM[8,1] * 2
  VAR.TOT.SUM = VAR.FIRST.DIGIT + VAR.SECOND.DIGIT + VAR.THIRD.DIGIT + VAR.FOURTH.DIGIT + VAR.FIFITH.DIGIT + VAR.SIXTH.DIGIT + VAR.SEVENTH.DIGIT + VAR.EIGHT.DIGIT
  VAR.DIV.NUM = VAR.TOT.SUM/11
  VAL.DIV.NUM = FIELD(VAR.DIV.NUM,'.',1)
  VAR.RESULT = VAR.TOT.SUM - (VAL.DIV.NUM * 11)
  IF VAR.RESULT EQ 0 THEN
    VAR.CHECK.DIGIT = 2
  END
  IF VAR.RESULT EQ 1 THEN
    VAR.CHECK.DIGIT = 1
  END
  IF VAR.RESULT NE 0 AND VAR.RESULT NE 1 THEN
    VAR.CHECK.DIGIT = 11 - VAR.RESULT
  END
  IF VAL.CHECK NE VAR.CHECK.DIGIT THEN
    ETEXT = "EB-REDO.INCORRECT.CHECKDIGIT"
    CALL STORE.END.ERROR
  END
  ELSE
    Y.CHECK.DIGIT = "PASS"
  END
  RETURN
END
