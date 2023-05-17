*
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.RATE.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.AA.INTEREST.ACCRUALS
$INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
$INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
*
  R.AA.INTEREST.ACCRUALS = RCL$COMM.LOAN(4)
  COMI = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1>
*
  RETURN
END
