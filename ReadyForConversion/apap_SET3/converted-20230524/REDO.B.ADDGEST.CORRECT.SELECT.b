SUBROUTINE REDO.B.ADDGEST.CORRECT.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CORRECT.COMMON

    CALL F.READ(FN.SL,'REDO.AA.CORRECT',ID.LIST,F.SL,RET.ERROR)
    IF ID.LIST NE '' THEN
        LIST.PARAM = ''
        CALL BATCH.BUILD.LIST(LIST.PARAM,ID.LIST)
    END

RETURN
END
