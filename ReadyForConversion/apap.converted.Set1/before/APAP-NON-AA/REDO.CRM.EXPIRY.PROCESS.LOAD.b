*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CRM.EXPIRY.PROCESS.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.EXPIRY.PROCESS.LOAD
*--------------------------------------------------------------------------------
* Description: This is batch routine to mark the REDO.ISSUE.REQUESTS records with
* SER.AGR.COMP as expired after the SLA days.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-May-2011    H GANESH         CRM             INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.CRM.EXPIRY.PROCESS.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
  FN.REDO.ISSUE.REQUESTS='F.REDO.ISSUE.REQUESTS'
  F.REDO.ISSUE.REQUESTS=''
  CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

  FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
  F.REDO.ISSUE.CLAIMS=''
  CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

  RETURN
END
