*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CNV.GET.COMP.ADDRESS

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB PROCESS

  RETURN
*--------------
PROCESS:
*-------------

  CHECK.COMPANY = O.DATA

  O.DATA = CHECK.COMPANY<1,3>

  RETURN
*--------------------------
END
