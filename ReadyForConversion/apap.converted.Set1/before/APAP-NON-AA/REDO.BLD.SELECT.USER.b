*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BLD.SELECT.USER(ENQ.DATA)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY

  FN.REDO.PAYMENT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
  F.REDO.PAYMENT  = ''
  CALL OPF(FN.REDO.PAYMENT,F.REDO.PAYMENT)

  LOCATE "INPUTTER" IN ENQ.DATA<2,1> SETTING INP.POS THEN
    Y.SEL.INP = ENQ.DATA<4,INP.POS>
    Y.SEL.INP1 = "...":Y.SEL.INP:"_..."
    ENQ.DATA<3,INP.POS> = 'LK'
    ENQ.DATA<4,INP.POS> = Y.SEL.INP1
  END
  RETURN
