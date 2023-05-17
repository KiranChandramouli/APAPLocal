*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.POLICY.AUTO.CANCEL.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : HARISH Y
* Program Name  : REDO.B.POLICY.AUTO.CANCEL
*-------------------------------------------------------------------------

* Description :This routine will SELECT the files required
*              by the routine REDO.B.POLICY.AUTO.CANCEL

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.APAP.H.INSURANCE.DETAILS
$INSERT I_REDO.B.POLICY.AUTO.CANCEL.COMMON

  GOSUB INIT
  GOSUB PROCESS

  RETURN

***********
INIT:
***********
  SEL.CMD="SELECT ":FN.APAP.H.INSURANCE.DETAILS
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN
********
PROCESS:
*********
  RETURN
END
