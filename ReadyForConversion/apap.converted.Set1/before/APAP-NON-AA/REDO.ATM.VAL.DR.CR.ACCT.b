*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ATM.VAL.DR.CR.ACCT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER

  IF R.NEW(FT.CREDIT.ACCT.NO) EQ R.NEW(FT.DEBIT.ACCT.NO) THEN

    ETEXT="EB-NO.VALID.TERM.ID"
    CALL STORE.END.ERROR
  END



  RETURN

END
