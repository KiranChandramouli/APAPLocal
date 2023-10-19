$PACKAGE APAP.TAM
SUBROUTINE REDO.HTML.DATA.PROCESS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.HTML.DATA.PROCESS
** 12-04-2023 R22 Auto Conversion 
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
        Y.USR.VAR = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.HTML.DATA"


*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE HTML.DATA = '' ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
    IF HTML.DATA.ERR THEN
        HTML.DATA=''
    END ;*Tus End

    HTML.DATA := O.DATA

*  WRITE HTML.DATA TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
    CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.DATA);*Tus End

RETURN
END
