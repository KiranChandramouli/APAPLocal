*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INT.CHECK.CRT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------

* Marimuthu S
* PACS00251842
*

  FN.AC = 'F.ACCOUNT'
  F.AC = ''
  CALL OPF(FN.AC,F.AC)

  Y.ID = R.NEW(FT.DEBIT.ACCT.NO)

  CALL F.READ(FN.AC,Y.ID,R.AC,F.AC,AC.ERR)
  IF NOT(R.AC) THEN
    CALL INT.ACC.OPEN(Y.ID,DSD)

    R.NEW(FT.DEBIT.ACCT.NO) = Y.ID
  END

  RETURN

END
