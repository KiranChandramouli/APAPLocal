*-----------------------------------------
* <Rating>0</Rating>
*-----------------------------------------
  SUBROUTINE REDO.FMT.ACH.REV.FT.ID

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.FT.REV.ID


  CALL JULDATE(GREGORIAN.DATE,JULIAN.DATE)
  JULIAN.DATE=JULIAN.DATE[3,7]
  Y.ID.FILE=COMI
  Y.LEN    =LEN(COMI)
  COMI     ='FT':JULIAN.DATE:Y.ID.FILE[11,Y.LEN]
  RETURN

END
