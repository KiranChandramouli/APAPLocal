*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.STOCK.DETAILS
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.AUT.STOCK.DETAILS
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter :
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*18/10/11      PACS001002015          Prabhu N                MODIFICAION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BENEFICIARY
$INSERT I_System
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.STOCK.ENTRY


  GOSUB OPEN.FILES
  GOSUB UPD.STK.FILE
  RETURN
*----------*
OPEN.FILES:
*-----------*
  FN.STK.DETAILS = "F.REDO.SAVE.STOCK.DETAILS"
  F.STK.DETAILS = ''
  CALL OPF(FN.STK.DETAILS,F.STK.DETAILS)

  RETURN
*------------*
UPD.STK.FILE:
*------------*

  ID.TO.UPDATE = R.NEW(STO.ENT.STOCK.ACCT.NO)
  STK.ID.UPDATE = ID.NEW

  FILE.NAME = FN.STK.DETAILS
  YCONCAT.ID = ID.TO.UPDATE
  V$FIELD = STK.ID.UPDATE
  V$INS = 'I'
  AR.OR.AL = 'AL'
  IF ID.TO.UPDATE THEN
    CALL CONCAT.FILE.UPDATE(FILE.NAME,YCONCAT.ID,V$FIELD,V$INS,AR.OR.AL)
  END

  RETURN
END
