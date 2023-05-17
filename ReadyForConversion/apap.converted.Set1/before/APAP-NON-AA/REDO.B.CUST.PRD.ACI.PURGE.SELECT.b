*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.PURGE.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CUST.PRD.ACI.PURGE

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON

  GOSUB PROCESS

  RETURN
*--------------------------
PROCESS:
*--------------------------
  PROCESS.LIST = ''
  PROCESS.LIST<2> = FN.REDO.BATCH.JOB.LIST.FILE
  CALL BATCH.BUILD.LIST(PROCESS.LIST,"")

  RETURN
END
