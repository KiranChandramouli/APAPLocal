*
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.CUS.ID.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.CUSTOMER
$INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
$INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

  R.CUSTOMER = RCL$COMM.LOAN(2)

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> THEN
    CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  END ELSE
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> THEN
      CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
    END ELSE
      CUSTOMER.ID = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END
  END
*
  COMI = CUSTOMER.ID
*
  RETURN
END
