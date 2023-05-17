SUBROUTINE REDO.VAL.ENQUIRY.REPORT
*--------------------------------------------------------
*Description: This input routine to check the field value and operand.
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY.REPORT

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------
    IF AF EQ ENQ.REP.LIST THEN
        GOSUB LIST.VALIDATION
    END

RETURN
*--------------------------------------------------------
LIST.VALIDATION:
*--------------------------------------------------------
*Validation are done here.

    Y.OPERAND = R.NEW(ENQ.REP.OPERAND)<1,AV,AS>
    IF COMI NE '' AND Y.OPERAND EQ '' THEN
        ETEXT = 'EB-REDO.BOTH.FIELD.MAND'
        CALL STORE.END.ERROR
    END
    IF COMI EQ '' AND Y.OPERAND NE '' THEN
        ETEXT = 'EB-REDO.BOTH.FIELD.MAND'
        CALL STORE.END.ERROR
    END

RETURN
END
