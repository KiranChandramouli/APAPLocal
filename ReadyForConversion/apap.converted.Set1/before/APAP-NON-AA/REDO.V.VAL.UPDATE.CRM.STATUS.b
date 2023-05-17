*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.UPDATE.CRM.STATUS
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This validation routine is used to update SER.AGR.PERF based on Status selected in closed
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRABHU N
* PROGRAM NAME : REDO.V.VAL.UPDATE.CRM.STATUS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 22.07.2010      PRABHU N            HD1100441         INITIAL CREATION
* 17.05.2011      Pradeep S           PACS00062662      CLOSING.DATE field was defaulted to TODAY
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.CLAIMS
$INSERT I_F.REDO.ISSUE.COMPLAINTS
$INSERT I_F.REDO.ISSUE.REQUESTS
$INSERT I_F.REDO.CLAIM.STATUS.MAP

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-------
INIT:
*-------
  FN.REDO.CLAIM.STAUS.MAP='F.REDO.CLAIM.STATUS.MAP'
  F.REDO.CLAIM.STAUS.MAP=''
  CALL OPF(FN.REDO.CLAIM.STAUS.MAP,F.REDO.CLAIM.STAUS.MAP)
  Y.CLOSING.STATUS=COMI
  Y.MAP.ID = APPLICATION:PGM.VERSION
  RETURN
*--------
PROCESS:
*--------

  CALL F.READ(FN.REDO.CLAIM.STAUS.MAP,Y.MAP.ID,R.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STAUS.MAP,ERR)

  IF R.REDO.CLAIM.STATUS.MAP THEN
    Y.CLOSED.STATUS=R.REDO.CLAIM.STATUS.MAP<CR.ST.CLOSED.STATUS>
    CHANGE VM TO FM IN Y.CLOSED.STATUS
    LOCATE COMI IN Y.CLOSED.STATUS SETTING Y.CLOSED.POS THEN
      Y.STATUS=R.REDO.CLAIM.STATUS.MAP<CR.ST.STATUS,Y.CLOSED.POS>
    END
    IF APPLICATION EQ 'REDO.ISSUE.CLAIMS' THEN
      R.NEW(ISS.CL.STATUS)=Y.STATUS
      R.NEW(ISS.CL.SER.AGR.PERF)=Y.STATUS
      R.NEW(ISS.CL.CLOSING.DATE)=TODAY
    END
    IF APPLICATION EQ 'REDO.ISSUE.COMPLAINTS' THEN
      R.NEW(ISS.COMP.STATUS)=Y.STATUS
      R.NEW(ISS.COMP.SER.AGR.PERF)=Y.STATUS
      R.NEW(ISS.COMP.CLOSING.DATE)=TODAY
    END
    IF APPLICATION EQ 'REDO.ISSUE.REQUESTS' THEN
      R.NEW(ISS.REQ.STATUS)=Y.STATUS
      R.NEW(ISS.REQ.SER.AGR.PERF)=Y.STATUS
      R.NEW(ISS.REQ.CLOSING.DATE)=TODAY
    END

  END
  RETURN
END
