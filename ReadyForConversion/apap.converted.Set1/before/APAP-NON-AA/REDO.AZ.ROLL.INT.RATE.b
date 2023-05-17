*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.ROLL.INT.RATE(GET.RATE)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of
*-------------------------------------------------------------
*Input Arg : GET.RATE
*Out Arg   : GET.RATE
*Deals With:
*-------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  CALL F.READ(FN.AZ.ACCOUNT,GET.RATE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
  IF R.AZ.ACCOUNT<AZ.ROLLOVER.INT.RATE> THEN
    GET.INT.RATE.VAL = R.AZ.ACCOUNT<AZ.ROLLOVER.INT.RATE>
  END ELSE
    GET.INT.RATE.VAL = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
  END

  GET.RATE = FMT(GET.INT.RATE.VAL,"16L,2")
  RETURN
END
