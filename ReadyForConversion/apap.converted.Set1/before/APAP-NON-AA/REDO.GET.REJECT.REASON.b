*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.REJECT.REASON(Y.REGULATORY,Y.REDO.REJECT.REASON)
*-----------------------------------------------------------------------------
*Description: This routine is to get the Reject Reason code
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  Y.REDO.REJECT.REASON = ''
  IF Y.REGULATORY ELSE
    RETURN
  END

  FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
  F.REDO.REJECT.REASON  = ''
  CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

  SEL.CMD = 'SELECT ':FN.REDO.REJECT.REASON:' WITH RETURN.CODE EQ "':Y.REGULATORY:'"'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

  Y.REDO.REJECT.REASON = SEL.LIST<1>

  RETURN
END
