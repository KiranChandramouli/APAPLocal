*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.R.COL.EXTRACT.ERROR(MSG, ROUTINE.NAME, Y.TABLE.ID)
********************************************************************
* Company   Name    : APAP
* Developed By      : Temenos Application Management mgudino@temenos.com
*--------------------------------------------------------------------------------------------
* Description:       This program Make the register of ERROR about extract
* Linked With:       REDO.COL.EXTRACT
* In Parameter:      MSG, ROUTINE.NAME, Y.TABLE.ID
* Out Parameter:
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 23/07/2009 - ODR-2009- XX-XXXX
* 14/09/2011 - PACS00110378              Cambio del uso de un regsitro en la aplicacion Locking
*           por almacenarlo en la Cola F.REDO.MSG.COL.QUEUE

$INSERT I_COMMON
$INSERT I_EQUATE

*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
PROCESS:

  R.REDO.COL.MSG.QUEUE<1> = ROUTINE.NAME
  R.REDO.COL.MSG.QUEUE<2> = "ERROR: ":MSG

*  WRITE R.REDO.COL.MSG.QUEUE TO F.REDO.COL.MSG.QUEUE, Y.MSG.QUEUE.ID ;*Tus Start 
CALL F.WRITE(FN.REDO.COL.MSG.QUEUE,Y.MSG.QUEUE.ID,R.REDO.COL.MSG.QUEUE);*Tus End
IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
CALL JOURNAL.UPDATE('')
END

  CALL OCOMO(MSG)

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:

  R.REDO.COL.MSG.QUEUE=""
  FN.REDO.COL.MSG.QUEUE='F.REDO.MSG.COL.QUEUE'
  F.REDO.COL.MSG.QUEUE = ''
  UNIQUE.TIME = ''
  CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
  Y.MSG.QUEUE.ID = Y.TABLE.ID:".":TODAY:".":ID.COMPANY:".":UNIQUE.TIME
  CALL OPF(FN.REDO.COL.MSG.QUEUE,F.REDO.COL.MSG.QUEUE)
  RETURN

END
