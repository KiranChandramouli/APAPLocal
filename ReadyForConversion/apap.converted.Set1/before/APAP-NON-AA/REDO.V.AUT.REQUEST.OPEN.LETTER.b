*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.REQUEST.OPEN.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.REQUESTS,NEW
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
* PROGRAM NAME : REDO.V.AUT.REQUEST.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.REQUESTS

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****

  FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
  F.REDO.ISSUE.REQUESTS  = ''
  CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)
  RETURN

********
PROCESS:
********
  Y.ID       = ID.NEW
  Y.STATUS   = R.NEW(ISS.REQ.STATUS)
  TASK.NAME  = "ENQ REDO.ENQ.REQUEST.STATUS.OPEN @ID EQ ":Y.ID

  IF Y.STATUS = 'OPEN' THEN
    CALL EB.SET.NEW.TASK(TASK.NAME)
  END
  RETURN
END
