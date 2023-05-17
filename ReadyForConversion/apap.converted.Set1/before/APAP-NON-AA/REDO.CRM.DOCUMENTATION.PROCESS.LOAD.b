*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS.LOAD
*--------------------------------------------------------------------------------
* Description: This is batch routine to mark the REDO.FRONT.REQUEST records with
* status as pending document after the calendar days defined in param table.
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
$INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
  FN.REDO.CRM.DOC.DATE='F.REDO.CRM.DOC.DATE'
  F.REDO.CRM.DOC.DATE=''
  CALL OPF(FN.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE)

  FN.REDO.CRM.CLAIM.DOC.DATE='F.REDO.CRM.CLAIM.DOC.DATE'
  F.REDO.CRM.CLAIM.DOC.DATE=''
  CALL OPF(FN.REDO.CRM.CLAIM.DOC.DATE,F.REDO.CRM.CLAIM.DOC.DATE)

  FN.REDO.FRONT.REQUESTS='F.REDO.FRONT.REQUESTS'
  F.REDO.FRONT.REQUESTS=''
  CALL OPF(FN.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS)

  FN.REDO.FRONT.CLAIMS='F.REDO.FRONT.CLAIMS'
  F.REDO.FRONT.CLAIMS=''
  CALL OPF(FN.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS)

  FN.REDO.H.CRM.PARAM = 'F.REDO.H.CRM.PARAM'
  F.REDO.H.CRM.PARAM  = ''
  CALL OPF(FN.REDO.H.CRM.PARAM,F.REDO.H.CRM.PARAM)

  RETURN
END
