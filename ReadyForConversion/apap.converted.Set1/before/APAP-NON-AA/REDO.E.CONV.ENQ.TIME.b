*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.ENQ.TIME

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_ENQUIRY.COMMON


  Y.TIME.VAL = ''
  Y.TIME.VAL = TIMEDATE()
  O.DATA = Y.TIME.VAL[1,8]
  RETURN
END
