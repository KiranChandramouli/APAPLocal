SUBROUTINE REDO.CRM.EXPIRY.PROCESS(Y.REQ.ID)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.EXPIRY.PROCESS
*--------------------------------------------------------------------------------
* Description:  This is batch routine to mark the REDO.ISSUE.REQUESTS records with
* SER.AGR.COMP as expired after the SLA days.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE                DESCRIPTION
* 24-May-2011     H GANESH         CRM                  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_REDO.CRM.EXPIRY.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    V.WORK.FILE.LIST = CONTROL.LIST<1,1>
    IF V.WORK.FILE.LIST EQ 'REQUEST' THEN
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.REQ.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQ.ERR)
        R.REDO.ISSUE.REQUESTS<ISS.REQ.SER.AGR.COMP>='EXPIRED'
        CALL F.WRITE(FN.REDO.ISSUE.REQUESTS,Y.REQ.ID,R.REDO.ISSUE.REQUESTS)
    END

    IF V.WORK.FILE.LIST EQ 'CLAIMS' THEN
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.REQ.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CL.ERR)
        R.REDO.ISSUE.CLAIMS<ISS.CL.SER.AGR.COMP>='EXPIRED'
        CALL F.WRITE(FN.REDO.ISSUE.CLAIMS,Y.REQ.ID,R.REDO.ISSUE.CLAIMS)
    END

RETURN
END
