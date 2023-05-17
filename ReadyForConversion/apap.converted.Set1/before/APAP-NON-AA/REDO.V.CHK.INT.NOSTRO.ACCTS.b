*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.INT.NOSTRO.ACCTS
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT


* Open file for reading

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT, F.ACCOUNT)

  Y.ACCT = COMI

  CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

  VAR.LIMIT.REF = R.ACCOUNT<AC.LIMIT.REF>
  VAR.CUSTOMER  = R.ACCOUNT<AC.CUSTOMER>


  IF VAR.CUSTOMER AND VAR.LIMIT.REF NE 'NOSTRO' THEN
    ETEXT = "TT-INT.ACCT"
    CALL STORE.END.ERROR
  END

  RETURN
*------------------
END
