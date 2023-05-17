*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.CLASS
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*
  Y.DATA = O.DATA
  Y.LEN = LEN(Y.DATA)
  O.DATA = Y.DATA[1,Y.LEN-1]
*
  RETURN
*
END
