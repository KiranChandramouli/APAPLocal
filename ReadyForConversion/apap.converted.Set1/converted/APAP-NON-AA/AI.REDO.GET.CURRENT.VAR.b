SUBROUTINE AI.REDO.GET.CURRENT.VAR
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.GET.CURRENT.VAR
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    CURRENT.VAR = O.DATA
    CURRENT.VALUE = System.getVariable(CURRENT.VAR)
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CURRENT.VALUE = ""
    END
    O.DATA = CURRENT.VALUE

RETURN
END
