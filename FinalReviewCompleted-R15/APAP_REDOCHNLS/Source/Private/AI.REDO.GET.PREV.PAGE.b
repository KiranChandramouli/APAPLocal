* @ValidationCode : MjotMTI5OTgzNjMxODpDcDEyNTI6MTY4NDg1NDA1MDI1MDpJVFNTOi0xOi0xOjE5NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS

SUBROUTINE AI.REDO.GET.PREV.PAGE
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.GET.PREV.PAGE
*-----------------------------------------------------------------------------
* DATE              WHO                REFERENCE               Description
* 04-APR-2023     Conversion tool    R22 Auto conversion      if condition added
* 04-APR-2023      Harishvikram C   Manual R22 conversion       No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)


    HTML.PREV.PAGE = ''
    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        Y.USR.VAR = ""
    END					;*R22 Auto conversion - End
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.PREV.PAGE"
*  READ HTML.PREV.PAGE FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE HTML.PREV.PAGE = '' ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.PREV.PAGE,F.REDO.EB.USER.PRINT.VAR,HTML.PREV.PAGE.ERR)
    IF HTML.PREV.PAGE.ERR THEN
        HTML.PREV.PAGE = ''
    END   ;*Tus End

    O.DATA = HTML.PREV.PAGE

RETURN
END
