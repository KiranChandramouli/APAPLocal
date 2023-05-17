*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS.SELECT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS.SELECT
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
$INSERT I_BATCH.FILES
$INSERT I_F.REDO.H.CRM.PARAM
$INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  CALL CACHE.READ(FN.REDO.H.CRM.PARAM,'SYSTEM',R.REDO.H.CRM.PARAM,CRM.PARAM.ERR)
  Y.DAYS      = R.REDO.H.CRM.PARAM<CRM.PARAM.SLA.EXPIRY>
  YREGION     = ''
  YDATE       = TODAY
  YDAYS.ORIG  = '-':Y.DAYS:'C'
  CALL CDT(YREGION,YDATE,YDAYS.ORIG)

  IF NOT(CONTROL.LIST) THEN
    CONTROL.LIST = "REQUEST"
    CONTROL.LIST<-1> = "CLAIMS"
  END

  V.WORK.LIST = CONTROL.LIST<1,1>
  IF V.WORK.LIST EQ 'REQUEST' THEN
    CALL F.READ(FN.REDO.CRM.DOC.DATE,YDATE,R.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE,CRM.ERR)
    Y.PROCESS.LIST = R.REDO.CRM.DOC.DATE
  END

  IF V.WORK.LIST EQ 'CLAIMS' THEN
    CALL F.READ(FN.REDO.CRM.CLAIM.DOC.DATE,YDATE,R.REDO.CRM.CLAIM.DOC.DATE,F.REDO.CRM.CLAIM.DOC.DATE,CRM.ERR.CLAIM)
    Y.PROCESS.LIST = R.REDO.CRM.CLAIM.DOC.DATE
  END

  CALL BATCH.BUILD.LIST('',Y.PROCESS.LIST)

  RETURN
END
