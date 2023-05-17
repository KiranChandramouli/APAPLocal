*
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.R.BCR.LOG(R.REDO.LOG)
*-----------------------------------------------------------------------------
* Simple Routine to wrap RED.INTERFACE.REC.ACT
*
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
* 17.04.12   hpasquel           PACS00191153                1.0
*------------------------------------------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
*
  COM/REDO.BCR.LOG/F.REDO.BCR.PROCESS.LOG,FN.REDO.BCR.PROCESS.LOG     ;* This allows to be used in another interfaces
*
  GOSUB INIT
  GOSUB PROCESS
  RETURN

*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
  CALL ALLOCATE.UNIQUE.TIME(Y.REDO.LOG.ID)
*

*  WRITE R.REDO.LOG TO F.REDO.BCR.PROCESS.LOG,Y.REDO.LOG.ID ;*Tus Start 
  CALL F.WRITE(FN.REDO.BCR.PROCESS.LOG,Y.REDO.LOG.ID,R.REDO.LOG) ;*Tus End
IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
CALL JOURNAL.UPDATE('')
END

  RETURN
*------------------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------------------
  IF NOT(FN.REDO.BCR.PROCESS.LOG) THEN
    FN.REDO.BCR.PROCESS.LOG = "F.REDO.BCR.PROCESS.LOG"
    CALL OPF(FN.REDO.BCR.PROCESS.LOG, F.REDO.BCR.PROCESS.LOG)
  END
  RETURN

*------------------------------------------------------------------------------------------------------------------
END
