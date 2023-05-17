*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AZ.ACC.BAL.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.AZ.ACC.BAL.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.AZ.ACC.BAL

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.AZ.CUSTOMER
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_F.PERIODIC.INTEREST
$INSERT I_REDO.B.AZ.ACC.BAL.COMMON

  DATE.NEXT.WORK = R.DATES(EB.DAT.NEXT.WORKING.DAY)
  SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GT ":TODAY:" AND MATURITY.DATE LE ":DATE.NEXT.WORK:" AND L.AZ.BAL.CONSOL NE ''"
  CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,RET.CODE)
  CALL BATCH.BUILD.LIST('',SEL.AZ.ACCOUNT.LIST)
  RETURN
END
