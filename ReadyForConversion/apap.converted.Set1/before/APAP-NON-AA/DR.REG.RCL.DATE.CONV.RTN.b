*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.DATE.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE

  OPEN.DATE = COMI
  IF OPEN.DATE THEN
    FORM.OPEN.DATE = OPEN.DATE[7,2]:'/':OPEN.DATE[5,2]:'/':OPEN.DATE[1,4]
    COMI = FORM.OPEN.DATE
  END ELSE
    COMI = ''
  END
  RETURN
END
