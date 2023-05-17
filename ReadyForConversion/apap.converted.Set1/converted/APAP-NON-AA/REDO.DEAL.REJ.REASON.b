SUBROUTINE REDO.DEAL.REJ.REASON(Y.REJ.CODE)
*--------------------------------------------------------
*Description: This routine is to return the description of return code
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.REJECT.REASON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------

    Y.REDO.REJ.CODE = Y.REJ.CODE
    Y.REJ.CODE      = ''


    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON  = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

    CALL F.READ(FN.REDO.REJECT.REASON,Y.REDO.REJ.CODE,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REJ.ERR)

    IF R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG> THEN
        Y.REJ.CODE = R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG>
    END ELSE
        Y.REJ.CODE = R.REDO.REJECT.REASON<REDO.REJ.DESC,1>
    END


RETURN
END
