*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.RP.NM

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  Y.DATA = O.DATA

  LOCATE 'PRINTSLIP'  IN Y.DATA<1,1> SETTING POS THEN
    Y.DATA<1,POS> = 'IF-01'
  END

  LOCATE 'LETTER' IN Y.DATA<1,1> SETTING POS.1  THEN
    Y.DATA<1,POS.1> = 'RECIBO'
  END

  O.DATA = Y.DATA

  RETURN

END
