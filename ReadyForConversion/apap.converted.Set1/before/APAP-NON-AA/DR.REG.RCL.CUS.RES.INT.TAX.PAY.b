*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.CUS.RES.INT.TAX.PAY
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.CUSTOMER
  $INSERT I_F.ACCOUNT
$INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
$INSERT I_DR.REG.INT.TAX.COMMON
*
*    AC.ID = COMI
  R.CUSTOMER = RCL$INT.TAX(3)
  COMI = R.CUSTOMER<EB.CUS.RESIDENCE>
*
END
