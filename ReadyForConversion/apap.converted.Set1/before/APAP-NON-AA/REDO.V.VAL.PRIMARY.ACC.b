*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.PRIMARY.ACC
*-----------------------------------------------------
*Decsription: This validation routine validates the entered account no.
*-----------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

  GOSUB PROCESS
  RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT =  ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  Y.ACC.NO = COMI
  CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF R.ACCOUNT THEN
    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF Y.ARR.ID THEN          ;* If it is a Loan Acc No. then error.
      ETEXT = 'EB-REDO.LOAN.ACC.NOT.ALLOWED'
      CALL STORE.END.ERROR
    END
    Y.AZ.PROD = R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT>
    IF Y.AZ.PROD THEN
      ETEXT = 'EB-REDO.DEPOSIT.ACC.NOT.ALLOWED'
      CALL STORE.END.ERROR
    END
  END
  RETURN
END
