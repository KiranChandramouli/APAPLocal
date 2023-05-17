*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.MONITOR.SHIP(MSG.ID)
*
*--------------------------------------------------------------------------------------
* Modifications:
*
* 03/09/10 - Created by Victor Nava
* 07/09/10 - Cesar Yepez. CALLJ to java program
*
*-------------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.MONITOR.SHIP.COMMON
*
*----------------------------------------------------------------------------------------
*
* Main processing section

  GOSUB INITIALISE
  GOSUB MAIN.PROCESSING
*
  RETURN
*
*---------------------------------------------------------------------------------------
*
INITIALISE:
*
  ERR.READ = ''
  R.MSG = ''
  ERR.MSG = ''
  ERR.TYPE = ''
  Y.MSG.SQL = ''
  Y.INSERT.SENTENCE = ''
  className = classNameInsert
  methodName = methodNameInsert
  ret = ''

*
  RETURN
*
*---------------------------------------------------------------------------------------
*
MAIN.PROCESSING:
*

  CALL F.READ(FN.REDO.MON.SEND.QUEUE, MSG.ID, R.MSG, F.REDO.MON.SEND.QUEUE, ERR.READ)
*
  IF ERR.READ THEN
    ERR.MSG = "MISSING REDO.MON.SEND.QUEUE RECORD " : MSG.ID
    ERR.TYPE = 'ERROR'
    GOSUB LOG.ERROR
    RETURN
  END ELSE
*
    Y.MSG.SQL = R.MSG<1>
    Y.MSG.SQL = Y.MSG.SQL : "@fm" : R.MSG<2>
    Y.MSG.SQL = Y.MSG.SQL : "@fm" : R.MSG<3>
    Y.MSG.SQL = Y.MSG.SQL : "@fm" : R.MSG<4>

    Y.INSERT.SENTENCE = R.MSG<10>

    CALLJ className,methodName,Y.MSG.SQL SETTING ret ON ERROR
      GOSUB errorHandler

      ERR.TYPE = 'ERROR'
      GOSUB LOG.ERROR
      RETURN
    END

    IF FIELD(ret,'|',1,1) EQ '2' THEN
      ERR.MSG = 'ERR RETURNED BY SQL JAVA PROGRAM ' : FIELD(ret,'|',1,2)
      ERR.TYPE = 'ERROR'
      GOSUB LOG.ERROR
      RETURN
    END


    CALL F.DELETE(FN.REDO.MON.SEND.QUEUE, MSG.ID)
*below lines commented for performance fix. No need to write the log for service completion-Prabhu N
*        ERR.TYPE = 'OK'
*        ERR.MSG = 'RECORD ID PROCESSED SUCCESSFULLY'
*        GOSUB LOG.ERROR


  END
*
  RETURN

*--------------------------------------------------------------------------
errorHandler:

  err = SYSTEM(0)

  BEGIN CASE
  CASE err = 1
    ERR.MSG = "Fatal Error creating Thread!"
  CASE err = 2
    ERR.MSG = "Cannot find the JVM.dll !"
  CASE err = 3
    ERR.MSG = "Class " : className : " doesn't exist!"
  CASE err = 4
    ERR.MSG = "UNICODE conversion error!"
  CASE err = 5
    ERR.MSG = "Method " : methodName : " doesn't exist!"
  CASE err = 6
    ERR.MSG = "Cannot find object Constructor!"
  CASE err = 7
    ERR.MSG = "Cannot instantiate object!"
  CASE @TRUE
    ERR.MSG = "Unknown error!"
  END CASE

  RETURN

*--------------------------------------------------------------------------
LOG.ERROR:
* Register error in the fault log

  INT.CODE = Y.INTERF.ID
  INT.TYPE = 'ONLINE'
  BAT.NO = ''
  BAT.TOT = ''
  INFO.OR = 'T24'
  INFO.DE = 'MONITOR'
  ID.PROC = MSG.ID
  MON.TP = ''
  DESC = ERR.MSG
*REC.CON = Y.INSERT.SENTENCE
  REC.CON = MSG.ID
  EX.USER = OPERATOR
  EX.PC = IP.ADDRESS

  BEGIN CASE
  CASE ERR.TYPE EQ 'WARNING'
    MON.TP = '05'
  CASE ERR.TYPE = 'ERROR'
    MON.TP = '08'
    CALL F.WRITE(FN.REDO.MON.SEND.QUEUE.ERR, MSG.ID, R.MSG)
    CALL F.DELETE(FN.REDO.MON.SEND.QUEUE, MSG.ID)
  CASE ERR.TYPE = 'OK'
    MON.TP = '01'
  END CASE

  CALL REDO.INTERFACE.REC.ACT(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC)

  RETURN

*--------------------------------------------------------------------------
END
