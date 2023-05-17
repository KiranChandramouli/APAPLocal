*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PAYMENT.AMT
*----------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  IF O.DATA ELSE
    RETURN
  END
  Y.AMT = FIELD(O.DATA,':',2)
  IF NUM(Y.AMT) AND Y.AMT THEN
    O.DATA = FIELD(O.DATA,':',1):" : ": TRIMB(FMT(Y.AMT,"L2,#19"))
  END


  RETURN

END
