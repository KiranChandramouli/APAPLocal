* @ValidationCode : MjotMTYzMDQzMjYxMTpDcDEyNTI6MTY4MDc4ODAxOTMyNDpJVFNTOi0xOi0xOjU4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:03:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 586
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.CLEAR.HTML.DATA.PROCESS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.CLEAR.HTML.DATA.PROCESS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - New condition added
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;** R22 Auto Conversion - Start
        Y.USR.VAR = ""
    END                                 ;** R22 Auto Conversion - End
    Y.USR.VAR.HTML = Y.USR.VAR:"-":"CURRENT.HTML.DATA"

*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML THEN ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
    IF HTML.DATA THEN  ;* Tus End

* DELETE F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML ;*Tus Start
        CALL F.DELETE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML);*Tus End
    END

    Y.USR.VAR.HTML = Y.USR.VAR:"-":"CURRENT.HTML.FOOTER"
*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML THEN ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
    IF HTML.DATA THEN  ;* Tus End
*    DELETE F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML ;*Tus Start
        CALL F.DELETE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML) ; *Tus End
    END
    CALL JOURNAL.UPDATE('')

RETURN
END
