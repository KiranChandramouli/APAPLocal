*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.ACI.UPD.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.ACI.UPD.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.ACI.UPD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.ACCOUNT
$INSERT I_F.BASIC.INTEREST
$INSERT I_F.DATES
$INSERT I_F.REDO.UPD.ACC.LIST
$INSERT I_F.REDO.ACC.CR.INT
$INSERT I_REDO.B.ACI.UPD.COMMON

  VAR.LAST.WORK.DAY=R.DATES(EB.DAT.LAST.WORKING.DAY)
  CALL F.READ(FN.REDO.UPD.ACC.LIST,VAR.LAST.WORK.DAY,R.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST,ACC.UPD.ERR)
  PROCESS.LIST=R.REDO.UPD.ACC.LIST
  IF PROCESS.LIST NE '' THEN
    CALL BATCH.BUILD.LIST('',PROCESS.LIST)
  END
  RETURN
END
