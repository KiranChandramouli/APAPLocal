*
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.CCY.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE

  CCY.VAL = COMI
  IF CCY.VAL EQ LCCY THEN
    LOAN.CCY = '1'
  END ELSE
    LOAN.CCY = '2'
  END
  COMI = LOAN.CCY
  RETURN
END
