*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.LIQ.AC.INT.TAX
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.STMT.ACCT.CR
$INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
$INSERT I_DR.REG.INT.TAX.COMMON

  AC.ID = FIELD(COMI,'-',1)
  R.STMT.ACCT.CR = RCL$INT.TAX(1)
  IF R.STMT.ACCT.CR<IC.STMCR.LIQUIDITY.ACCOUNT> EQ '' THEN
    CREDIT.ACCOUNT = AC.ID
  END ELSE
    CREDIT.ACCOUNT = R.STMT.ACCT.CR<IC.STMCR.LIQUIDITY.ACCOUNT>
  END
  COMI = CREDIT.ACCOUNT
  RETURN
END
