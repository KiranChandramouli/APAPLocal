*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.AMT.DEBIT(Y.AMT.DEBIT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :KREDO.S.AMT.DEBIT
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the debited amount for the paticular transaction
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER

  GOSUB PROCESS
  RETURN

PROCESS:

  Y.OUT = R.NEW(FT.AMOUNT.DEBITED)
  LEN.AMT.DBT = LEN(Y.OUT)
  AMT.DEBIT = Y.OUT[4,LEN.AMT.DBT]
  Y.AMT.DEBIT = TRIM(FMT(AMT.DEBIT,"L2,#19")," ",'B')
  RETURN

END
