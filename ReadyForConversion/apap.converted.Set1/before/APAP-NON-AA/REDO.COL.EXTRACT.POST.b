* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-37</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.EXTRACT.POST
*-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT post process
* Single job Routine
*
* Allows to check if the extraction process was done sucessfully
*-----------------------------------------------------------------------------
* Modification History:
*            2010-11-16 : C.1 APAP First version
*            2011-09-14 : C.1 No leer la Cola de Cliente para verificar si el proceso termino
*                             Leer la Cola de log y enviar al C.22
*                             Ver si la bandera de procesamiento esta en blando para borrarla
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.COL.EXTRACT.PRE.COMMON
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN
*------------------------------------------
INITIALISE:
*------------------------------------------
  IF NOT(F.LOCKING) THEN
    FN.LOCKING = "F.LOCKING"
    CALL OPF(FN.LOCKING, F.LOCKING)
  END
* Check if The process was already done
  R.LOCKING = ''
  Y.LOCKING.ID = C.RED.LOKING.ID : "." : TODAY

  IF NOT(FN.REDO.MSG.COL.QUEUE) THEN
    FN.REDO.MSG.COL.QUEUE = "F.REDO.MSG.COL.QUEUE"
    F.REDO.MSG.COL.QUEUE = ""
  END

  CALL OPF(FN.REDO.MSG.COL.QUEUE,F.REDO.MSG.COL.QUEUE)

  C.INT.CODE='COL001'
  C.INT.TYPE='BATCH'
  C.BAT.NO=1
  C.BAT.TOT=0
  C.INFO.OR=''
  C.INFO.DE=''
  C.ID.PROC=C.BAT.NO
  C.MON.TP='01'
  C.DESC=''
  C.REC.CON=''
  C.EX.USER=OPERATOR
  C.EX.PC=TNO

  Y.SELECT.STATEMENT = 'SELECT ':FN.REDO.MSG.COL.QUEUE
  Y.REDO.MSG.QUEUE.COL = ''
  Y.LIST.NAME = ''
  NO.OF.REC = ''
  R.QUEUE.REC = ''
  Y.SYSTEM.RETURN.CODE = ''
  QUEUE.ID = ''
  Y.MARK   = ''
  YERR     = ''
  POS      = ''

  RETURN
*------------------------------------------
PROCESS:
*------------------------------------------
* C.RED.LOKING.ID='REDO.COL.EXTRACT.TRACE'
  CALL F.READ(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,F.LOCKING,YERR)

* This entry must exist only if previouly the process was already done successfully
*    READ R.LOCKING FROM F.LOCKING, Y.LOCKING.ID THEN
* ignore this process
*    END

  R.LOCKING<1> = ''
  R.LOCKING<2> = 'EXTRACT PROCESS FOR ' : TODAY : " WAS DONE"

  WRITE R.LOCKING TO F.LOCKING, Y.LOCKING.ID


  CALL EB.READLIST(Y.SELECT.STATEMENT,Y.REDO.MSG.QUEUE.COL,Y.LIST.NAME,NO.OF.REC,Y.SYSTEM.RETURN.CODE)

  LOOP
    REMOVE QUEUE.ID FROM Y.REDO.MSG.QUEUE.COL SETTING Y.MARK
  WHILE QUEUE.ID : Y.MARK
    FINDSTR "TMP" IN QUEUE.ID SETTING POS THEN
*HAS TO BE EMPTY
    END
    ELSE

      CALL CACHE.READ(FN.REDO.MSG.COL.QUEUE,QUEUE.ID,R.QUEUE.REC,YERR)
      C.ID.PROC = QUEUE.ID
      C.DESC    = R.QUEUE.REC
      CALL REDO.INTERFACE.REC.ACT(C.INT.CODE,C.INT.TYPE,C.BAT.NO,C.BAT.TOT,C.INFO.OR,C.INFO.DE,C.ID.PROC,C.MON.TP,C.DESC,C.REC.CON,C.EX.USER,C.EX.PC)
      CALL F.DELETE (FN.REDO.MSG.COL.QUEUE, QUEUE.ID)       ;*DELETE F.REDO.MSG.COL.QUEUE, QUEUE.ID
    END
  REPEAT



  RETURN
*------------------------------------------------------------------------------------------------
END
