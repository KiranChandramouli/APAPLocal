*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NON.CONFIRM.PAY.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.NON.CONFIRM.PAY

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ADMIN.CHQ.PARAM
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS
$INSERT I_REDO.B.NON.CONFIRM.PAY.COMMON

  SEL.CMD=''
  SEL.LIST=''
  NO.OF.REC=''
  ERR=''
  SEL.CMD="SELECT ":FN.REDO.ADMIN.CHQ.DETAILS:" WITH STOP.PAID.DATE LE ":BEFORE.X.DAYS:" AND STATUS EQ STOP.PAID.NON.CNFRM"
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN
END
