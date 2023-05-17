*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.CCY.FXRTE(Y.CCY)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.DS.FCY.FX
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the F.Currency type of the txn.
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
*
  IF Y.CCY.1 NE Y.CCY.2 AND R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
    Y.CCY = Y.CCY.2
  END
*
  IF Y.CCY.1 NE Y.CCY.2 AND R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
    Y.CCY = Y.CCY.1
  END
*
  RETURN
*
*****
INIT:
*****
*
  Y.CCY.1        = ""
  Y.CCY.2        = ""
*
  IF APPLICATION EQ "TELLER" THEN
    Y.CCY.1  = R.NEW(TT.TE.CURRENCY.1)
    Y.CCY.2  = R.NEW(TT.TE.CURRENCY.2)
  END
*
  RETURN
*
END
