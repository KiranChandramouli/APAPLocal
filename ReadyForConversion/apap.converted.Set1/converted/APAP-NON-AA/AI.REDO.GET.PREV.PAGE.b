SUBROUTINE AI.REDO.GET.PREV.PAGE
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.GET.PREV.PAGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)


    HTML.PREV.PAGE = ''
    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.PREV.PAGE"
*  READ HTML.PREV.PAGE FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE HTML.PREV.PAGE = '' ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.PREV.PAGE,F.REDO.EB.USER.PRINT.VAR,HTML.PREV.PAGE.ERR)
    IF HTML.PREV.PAGE.ERR THEN
        HTML.PREV.PAGE = ''
    END   ;*Tus End

    O.DATA = HTML.PREV.PAGE

RETURN
END
