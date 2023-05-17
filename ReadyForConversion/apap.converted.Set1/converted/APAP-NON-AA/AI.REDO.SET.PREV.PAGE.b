SUBROUTINE AI.REDO.SET.PREV.PAGE
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.SET.PREV.PAGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    HTML.PREV.PAGE = O.DATA
    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.PREV.PAGE"
*  WRITE HTML.PREV.PAGE TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
    CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.PREV.PAGE)

RETURN
END
