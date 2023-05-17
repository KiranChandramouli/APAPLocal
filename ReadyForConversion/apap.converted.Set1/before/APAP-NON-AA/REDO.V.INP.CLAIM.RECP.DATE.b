*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.CLAIM.RECP.DATE
*-----------------------------------------------------------------------------
* DESCRIPTION:
* ------------
* This is Input routine to update the values of DATE & TIME field of REDO.ISSUE.CLAIMS
* at the time of commitment
* This development is for ODR Reference ODR-2009-12-0283
* Input/Output:
*--------------
* IN  : N/A
* OUT : N/A
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who              Reference            Description
* 27-JUL-2010       B Renugadevi     ODR-2009-12-0283    Initial Creation
*13-MAR-2011        Prabhu N         HD1100441           Manadatory check removed for the fields ISS.CL.CLIENT.CONTACTED,ISS.CL.NOTES,ISS.CL.CLOSE.NOTIFICATION
*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.CLAIMS

  GOSUB INIT
  GOSUB PROCESS
  RETURN

******
INIT:
******
  FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
  F.REDO.ISSUE.CLAIMS  = ''
  CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
  RETURN

*********
PROCESS:
*********
  Y.TIME  = OCONV(TIME(), 'MTS')
  IF R.NEW(ISS.CL.STATUS) EQ "OPEN" THEN
    R.NEW(ISS.CL.OPENING.DATE) = TODAY
  END
  IF R.NEW(ISS.CL.STATUS) EQ 'RESOLVED NOTIFIED' THEN
    R.NEW(ISS.CL.DATE.NOTIFICATION) = TODAY
  END
  IF R.NEW(ISS.CL.STATUS) EQ 'CLOSED' THEN
    R.NEW(ISS.CL.CLOSING.DATE) = TODAY
    GOSUB UPDATE.CLOSED.FIELD
  END
  R.NEW(ISS.CL.RECEPTION.TIME) = Y.TIME
  RETURN
********************
UPDATE.CLOSED.FIELD:
********************

  IF R.NEW(ISS.CL.CLOSING.STATUS) EQ ''  THEN
    AF = ISS.CL.CLOSING.STATUS
    ETEXT = 'EB-INPUT.MAND'
    CALL STORE.END.ERROR
  END

  IF R.NEW(ISS.CL.CLOSING.REMARKS) EQ '' THEN
    AF = ISS.CL.CLOSING.REMARKS
    ETEXT = 'EB-INPUT.MAND'
    CALL STORE.END.ERROR
  END

  IF R.NEW(ISS.CL.INTERNAL.REMARKS) EQ '' THEN
    AF = ISS.CL.INTERNAL.REMARKS
    ETEXT = 'EB-INPUT.MAND'
    CALL STORE.END.ERROR
  END

  IF R.NEW(ISS.CL.USER.REMARKS) EQ '' THEN
    AF = ISS.CL.USER.REMARKS
    ETEXT = 'EB-INPUT.MAND'
    CALL STORE.END.ERROR
  END

  RETURN
*-----------------------------------------------------------------------------------------------------
END
