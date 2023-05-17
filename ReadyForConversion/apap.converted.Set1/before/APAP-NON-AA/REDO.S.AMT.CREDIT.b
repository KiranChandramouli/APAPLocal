*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.AMT.CREDIT(Y.AMT.CREDIT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.AMT.CREDIT
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the credite amount for particular transaction
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER

  GOSUB PROCESS
  RETURN

PROCESS:

  Y.OUT = R.NEW(FT.AMOUNT.CREDITED)
  LEN.AMT.CRD = LEN(Y.OUT)
  AMT.CREDIT = Y.OUT[4,LEN.AMT.CRD]
  Y.AMT.CREDIT = TRIM(FMT(AMT.CREDIT,"L2,#19")," ",'B')
  RETURN

END
