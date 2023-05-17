*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.MONITOR.MAP.LOAD
*
*
*
*--------------------------------------------------------------------------
* Modifications;
*
* 30/08/10 - Created by Cesar Yepez
*

*--------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.MONITOR.MAP.COMMON
*
*--------------------------------------------------------------------------
*
* Main processing

  FN.REDO.MON.MAP.QUEUE = 'F.REDO.MON.MAP.QUEUE'
  F.REDO.MON.MAP.QUEUE = ''
  CALL OPF(FN.REDO.MON.MAP.QUEUE, F.REDO.MON.MAP.QUEUE)

  FN.REDO.MON.SEND.QUEUE = 'F.REDO.MON.SEND.QUEUE'
  F.REDO.MON.SEND.QUEUE = ''
  CALL OPF(FN.REDO.MON.SEND.QUEUE, F.REDO.MON.SEND.QUEUE)

  FN.REDO.MON.TABLE = 'F.REDO.MONITOR.TABLE'
  F.REDO.MON.TABLE = ''
  CALL OPF(FN.REDO.MON.TABLE, F.REDO.MON.TABLE)

  FN.REDO.MON.MAP.QUEUE.ERR = 'F.REDO.MON.MAP.QUEUE.ERR'
  F.REDO.MON.MAP.QUEUE.ERR = ''
  CALL OPF(FN.REDO.MON.MAP.QUEUE.ERR, F.REDO.MON.MAP.QUEUE.ERR)


*
  RETURN
*
*--------------------------------------------------------------------------
*
END
