*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.LCY.CHQ.OUTWARD
*------------------------------------------------------
*Description: This conversion routine is to display the APAP account no.
* in case if that cheque is for payment.
*------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.CLEARING.OUTWARD
$INSERT I_F.REDO.OUTWARD.RETURN
$INSERT I_F.ALTERNATE.ACCOUNT

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------

  FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
  F.REDO.OUTWARD.RETURN  = ''
  CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

  FN.ALTERNATE.ACCOUNT  = 'F.ALTERNATE.ACCOUNT'
  F.ALTERNATE.ACCOUNT   = ''
  CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

  RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

  IF R.RECORD<CLEAR.OUT.TFS.REFERENCE> EQ 'PAYMENT' THEN
    GOSUB CHECK.RETURN.CHQ
  END
  RETURN
*------------------------------------------------------
CHECK.RETURN.CHQ:
*------------------------------------------------------
  Y.RET.FLAG = ''
  CALL F.READ(FN.REDO.OUTWARD.RETURN,ID,R.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN,ROR.ERR)
  IF R.REDO.OUTWARD.RETURN THEN
    Y.RETURN.ALT.ID = R.REDO.OUTWARD.RETURN<CLEAR.RETURN.ACCOUNT>
    Y.ACC.ID        = FMT(Y.RETURN.ALT.ID,'11"0"R')
    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ACC.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ALT.ERR)
   * O.DATA = R.ALTERNATE.ACCOUNT<1> ;*Tus Start
    O.DATA = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER> ;*Tus End
  END
  RETURN
END
