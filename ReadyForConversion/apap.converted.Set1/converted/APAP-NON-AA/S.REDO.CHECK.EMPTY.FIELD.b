FUNCTION S.REDO.CHECK.EMPTY.FIELD(F.NO, M.NO, S.NO, CALL.SEE)
*-----------------------------------------------------------------------------
* Allows to check if the R.NEW content is blank or empty
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
*
* Input
* ------------
*                 F.NO          Field Number
*                 M.NO          Multivalue position
*                 S.NO          Subvalue position
*                 CALL.SEE      @TRUE if the routine has to call STORE.END.ERROR
*
* Output
* --------------
*                returns @TRUE if the current value is empty or blank
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN Y.RETURN

* ----------------------------------------------------------------------------------
INITIALISE:
* ----------------------------------------------------------------------------------
    IF M.NO EQ '' THEN
        M.NO = 1
    END
    IF S.NO EQ '' THEN
        S.NO = 1
    END
    IF CALL.SEE EQ '' THEN
        CALL.SEE = @FALSE
    END

RETURN
* ----------------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------------

    Y.RETURN = R.NEW(F.NO)<1,M.NO,S.NO> EQ ''
    IF Y.RETURN AND CALL.SEE THEN
        AF = F.NO
        AV = M.NO
        AS = S.NO
        ETEXT = "EB-INPUT.MISSING"
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
END
