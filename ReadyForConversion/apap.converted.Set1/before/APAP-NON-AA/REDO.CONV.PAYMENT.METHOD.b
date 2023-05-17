*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PAYMENT.METHOD
*--------------------------------------------------------
*Description: This conversion routine is to get the payment method
*             for a loan in overview screen.
*--------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.PAYMENT.SCHEDULE
$INSERT I_F.DYNAMIC.TEXT

  GOSUB PROCESS
  RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------


  LOCATE "ARRANGEMENT.ID" IN ENQ.SELECTION<2,1> SETTING POS1 THEN
    Y.ARR.ID = ENQ.SELECTION<4,POS1>
  END ELSE
    RETURN
  END


  LOC.REF.APPLICATION   = "AA.PRD.DES.PAYMENT.SCHEDULE"
  LOC.REF.FIELDS        = 'L.AA.PAY.METHD'
  LOC.REF.POS           = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AA.PAY.METHD    = LOC.REF.POS<1,1>

  EFF.DATE   = ''
  PROP.CLASS ='PAYMENT.SCHEDULE'
  PROPERTY   = ''
  R.CONDITION= ''
  ERR.MSG    = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
  Y.PAYMENT.METHOD = R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD>
  GOSUB GET.TEXT
  RETURN
*------------------------------------------
GET.TEXT:
*------------------------------------------
  FN.DYNAMIC.TEXT = 'F.DYNAMIC.TEXT'
  F.DYNAMIC.TEXT  = ''
  CALL OPF(FN.DYNAMIC.TEXT,F.DYNAMIC.TEXT)

  CHANGE ' ' TO '.' IN Y.PAYMENT.METHOD
  CALL F.READ(FN.DYNAMIC.TEXT,Y.PAYMENT.METHOD,R.DYNAMIC.TXT,F.DYNAMIC.TEXT,DY.ERR)
  IF R.DYNAMIC.TXT THEN
    IF R.DYNAMIC.TXT<LNGG> THEN
      O.DATA = R.DYNAMIC.TXT<LNGG>
    END ELSE
  *    O.DATA = R.DYNAMIC.TXT<1> ;*Tus Start
      O.DATA = R.DYNAMIC.TXT<EB.DYNAMIC.TEXT.1> ;*Tus End
    END
  END

  RETURN
END
