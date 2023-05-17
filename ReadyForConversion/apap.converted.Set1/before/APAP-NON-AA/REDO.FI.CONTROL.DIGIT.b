*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.CONTROL.DIGIT(IN.TEXT,IN.DIG,IN.ERR)
******************************************************************************
*     Control Digit Calculation
*     IN.TEXT       INPUT          STRING TO VALIDATE
*     IN.DIG        OUTPUT         CONTROL DIGIT VALUE
*     IN.ERR        OUTPUT         ERROR CODE
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : AVELASCO
*    Date          : 2010/Oct/20
*
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
  RETURN

* ======
PROCESS:
* ======
  FOR INI.POS = 1 TO Y.TEXT.LEN
    Y.CHAR = SUBSTRINGS (Y.TEXT, INI.POS, 1)
    Y.ASCII= SEQ(Y.CHAR)
    Y.SUM +=  Y.ASCII
  NEXT INI.POS

  IN.DIG = Y.SUM * 13

  RETURN

* ---------
INITIALISE:
* ---------
  PROCESS.GOAHEAD = 1
  IN.ERR = ""
  IN.DIG = ""
  Y.TEXT = ""
  Y.LEN  = 0
  Y.SUM  = 0

  Y.TEXT = CHANGE (IN.TEXT,",","-")

  RETURN

* ---------
OPEN.FILES:
* ---------
  RETURN

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
  LOOP.CNT  = 1   ;   MAX.LOOPS = 1
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
      Y.TEXT.LEN = LEN (Y.TEXT)

      IF Y.TEXT.LEN LT 1 THEN
        PROCESS.GOAHEAD = 0
        IN.ERR = 1
        E = "EB-ERROR.NO.INPUT.DATA"
        CALL ERR
      END
    END CASE
    LOOP.CNT +=1
  REPEAT
  RETURN
END
