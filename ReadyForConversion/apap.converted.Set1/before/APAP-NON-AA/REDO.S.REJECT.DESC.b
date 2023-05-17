*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.REJECT.DESC(DESC)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.REJECT.DESC
*Reference         :ODR2010090251
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Reject Reason decription
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.OUTWARD.RETURN
$INSERT I_F.REDO.REJECT.REASON

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:
*Opening Files

  FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
  F.REDO.OUTWARD.RETURN = ''
  CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

  FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
  F.REDO.REJECT.REASON = ''
  CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

  RETURN
PROCESS:
*Getting the Description of the Reject Code

  VAR.PAYMENT.DETAILS = R.NEW(FT.PAYMENT.DETAILS)
  CALL F.READ(FN.REDO.OUTWARD.RETURN,VAR.PAYMENT.DETAILS,R.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN,OUTWARD.ERR)
  VAR.REJECT.ID = R.REDO.OUTWARD.RETURN<CLEAR.RETURN.REJECT.REASON>
  CALL F.READ(FN.REDO.REJECT.REASON,VAR.REJECT.ID,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REASON.ERR)
  IF R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG> THEN
    DESC = R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG>
  END ELSE
    DESC = R.REDO.REJECT.REASON<REDO.REJ.DESC,1>
  END
  RETURN
END
