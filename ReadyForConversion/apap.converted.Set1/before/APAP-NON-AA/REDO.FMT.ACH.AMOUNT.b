*-----------------------------------------
* <Rating>0</Rating>
*-----------------------------------------
  SUBROUTINE REDO.FMT.ACH.AMOUNT

$INSERT I_COMMON
$INSERT I_EQUATE

  AMT.FILE=COMI
  Y.AMT=COMI


  Y.AMT=Y.AMT/100

  COMI=Y.AMT


  RETURN

END
