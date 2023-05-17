*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.COMPLAINT.CLOSE.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for CLOSE letter and this routine
* is attached to REDO.ISSUE.COMPLAINTS,NEW
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.COMPLAINT.CLOSE.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* 19.MAY.2011       Pradeep S          PACS00060849      PDF Generated during notification
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.COMPLAINTS

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****

  FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
  F.REDO.ISSUE.COMPLAINTS  = ''
  CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
  RETURN

********
PROCESS:
********
  Y.ID       = ID.NEW
  Y.STATUS   = R.NEW(ISS.COMP.CLOSE.NOTIFICATION)
  TASK.NAME  = "ENQ REDO.ENQ.COMPLAINTS.STATUS.CLOSE @ID EQ ":Y.ID

*IF Y.STATUS EQ 'YES' THEN
  CALL EB.SET.NEW.TASK(TASK.NAME)
*END
  RETURN
END
