*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.APAP.VAL.CR.CHANNEL
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CR.CONTACT.LOG

  IF COMI NE "" THEN
    R.NEW(CR.CONT.LOG.CONTACT.CHANNEL) = COMI
  END

  RETURN
END
