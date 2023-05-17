SUBROUTINE REDO.E.CNV.REJECT.DESC
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      PACS00190859  KAVITHA     For enquiry
*
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.USER
    $INSERT I_F.REDO.REJECT.REASON

    GOSUB OPEN.PARA
    GOSUB PROCESS

RETURN
*-----------------------
OPEN.PARA:

    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)


RETURN

PROCESS:
**********

    REDO.REJECT.REASON.ID = O.DATA
    LANGUAGE.CODE = LNGG

    CALL F.READ(FN.REDO.REJECT.REASON,REDO.REJECT.REASON.ID,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REDO.REJECT.REASON.ERR)

    IF R.REDO.REJECT.REASON THEN
        O.DATA = R.REDO.REJECT.REASON<REDO.REJ.DESC,LANGUAGE.CODE>
    END

    IF NOT(O.DATA) THEN
        O.DATA = R.REDO.REJECT.REASON<REDO.REJ.DESC,1>
    END


RETURN
END
