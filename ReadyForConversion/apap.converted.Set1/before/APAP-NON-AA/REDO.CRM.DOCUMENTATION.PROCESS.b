*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS(Y.REQ.ID)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS
*--------------------------------------------------------------------------------
* Description:  This is batch routine to mark the REDO.FRONT.REQUEST records with
* status as pending document after the calendar days defined in param table.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE                DESCRIPTION
*  24-May-2011   H GANESH       PACS00071941             INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_F.REDO.FRONT.REQUESTS
$INSERT I_F.REDO.FRONT.CLAIMS
$INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  V.WORK.FILE.LIST = CONTROL.LIST<1,1>
  IF V.WORK.FILE.LIST EQ 'REQUEST' THEN
    CALL F.READ(FN.REDO.FRONT.REQUESTS,Y.REQ.ID,R.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS,FR.REQ.ERR)
    R.REDO.FRONT.REQUESTS<FR.CM.CLOSING.STATUS>='PENDING-DOCUMENTATION'
    R.REDO.FRONT.REQUESTS<FR.CM.STATUS>='CLOSED'
    R.REDO.FRONT.REQUESTS<FR.CM.CLOSING.DATE>=TODAY
    CALL F.WRITE(FN.REDO.FRONT.REQUESTS,Y.REQ.ID,R.REDO.FRONT.REQUESTS)
  END

  IF V.WORK.FILE.LIST EQ 'CLAIMS' THEN
    CALL F.READ(FN.REDO.FRONT.CLAIMS,Y.REQ.ID,R.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS,FR.CL.ERR)
    R.REDO.FRONT.REQUESTS<FR.CL.CLOSING.STATUS>='PENDING-DOCUMENTATION'
    R.REDO.FRONT.REQUESTS<FR.CL.STATUS>='CLOSED'
    R.REDO.FRONT.REQUESTS<FR.CL.CLOSING.DATE>=TODAY
    CALL F.WRITE(FN.REDO.FRONT.CLAIMS,Y.REQ.ID,R.REDO.FRONT.CLAIMS)
  END


  RETURN
END
