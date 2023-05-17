*------------------------------------------------------------------------------------
* <Rating>-59</Rating>
*------------------------------------------------------------------------------------
  SUBROUTINE REDO.FI.RECORD.CONTROL(O.ERROR.MSG)
*************************************************************************************
*    Save records in REDO.FI.CONTROL
*    Parameters:
*        O.ERR.MSG:  Output parameter to send the ERROR message get in the process
* ===================================================================================
*
*    First Release :R9
*    Developed for :APAP
*    Developed by  :Ana Noriega
*    Date          :2010/Oct/25
*
*====================================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.FI.VARIABLES.COMMON
$INSERT I_F.REDO.FI.CONTROL
*
*=====================================================================================
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
* ======
PROCESS:
* ======

* Read record


  CALL F.READ(FN.REDO.FI.CON, Y.REDO.FI.CON.ID, R.REDO.FI.CON, F.REDO.FI.CON, Y.ERR.REDO.FI.CON)

  IF R.REDO.FI.CON THEN
    FOR I = 1 TO Y.TOT.REDO.FI.CON.FIELDS
      R.REDO.FI.CON<I> = FI.W.REDO.FI.CONTROL<I>
    NEXT
  END ELSE
    R.REDO.FI.CON = FI.W.REDO.FI.CONTROL
  END

*   Save the record

*     CALL F.WRITE(FN.REDO.FI.CON,Y.REDO.FI.CON.ID,R.REDO.FI.CON)
  WRITE R.REDO.FI.CON TO F.REDO.FI.CON, Y.REDO.FI.CON.ID 
*     CALL JOURNAL.UPDATE(Y.REDO.FI.CON.ID)
*
  RETURN
*

*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    CALL TXT(Y.ERR)
    O.ERROR.MSG     = Y.ERR
  END
*
  RETURN
*
* ---------
INITIALISE:
* ---------
*
  PROCESS.GOAHEAD = 1
*
* RECORD IN REDO.FI.CONTROL
  FN.REDO.FI.CON           = "F.REDO.FI.CONTROL"
  F.REDO.FI.CON            = ""
  Y.REDO.FI.CON.ID         = FI.W.REDO.FI.CONTROL.ID
  Y.ERR.REDO.FI.CON        = ""
  Y.TOT.REDO.FI.CON.FIELDS = REDO.FI.CON.RECORD.STATUS -1
*
  Y.ERR = ""
  FI.DATO.NUM.REG          = ""
  FI.DATO.MONTO.TOTAL      = ""
  FI.CALC.NUM.REG          = ""
  FI.CALC.MONTO.TOTAL      = ""

  RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*   OPEN  REDO.FI.CONTROL
  CALL OPF(FN.REDO.FI.CON,F.REDO.FI.CON)
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
*        VALIDATE THAT RECORD EXISTS
      IF FI.W.REDO.FI.CONTROL EQ "" THEN
        Y.ERR = "EB-ERROR.NOT.EXISTS.REC.CTRL"
      END
    CASE LOOP.CNT EQ 2
*        VALIDATES THAT THERE ARE ALL DATA TAGS
      IF FI.W.REDO.FI.CONTROL.ID EQ ""  THEN
        Y.ERR = "EB-ERROR.NOT.EXISTS.ID.CTRL"
      END
    END CASE
    LOOP.CNT +=1
  REPEAT

*   MESSAGE ERROR
  GOSUB CONTROL.MSG.ERROR
*
  RETURN
*
END
