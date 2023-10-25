* @ValidationCode : MjoxNzY0ODk4NDE3OkNwMTI1MjoxNjk4MjM3MjE0NzI0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:03:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.EXPIRED.EXT.USERP(ACTION.INFO, REQUEST, MOB.RESPONSE, MOB.ERROR)
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
* Description :
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_EB.MOB.FRMWRK.COMMON
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB CHANGE.PASSWORD

    RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    PROFILE.ARGS = ''

    PROFILE.ARGS<1> = 'BROWSER'
    PROFILE.ARGS<2> = 'PROCESS.REPEAT'
    PROFILE.ARGS<3> = REQUEST[',', 1, 1]
    PROFILE.ARGS<4> = REQUEST[',', 2, 1]
    PROFILE.ARGS<6> = EXT.USER.ID

    USER.NAME = EXT.USER.ID
    PASSWORD = REQUEST[',', 1, 1]

*       CALL EB.EXTERNAL.USER.SWITCH('', EXT.USER.ID)

*       OPERATOR = OFS$SOURCE.REC<OFS.SRC.GENERIC.USER>

    RETURN

*---------------------------------------------------------------------------------------------------
CHANGE.PASSWORD:

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = 'INTERNET'  ;* Just tell VSO that we are validating EB.EXTERNAL.USER

    ACT.SOURCE.TYPE = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>

    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = 'SESSION'         ;* Just tell VSO that we are validating EB.EXTERNEL.USER

*       CALL VALIDATE.SIGN.ON(USER.NAME, PASSWORD)    ;* Validates Internet user/password.

    OPERATOR = OFS$SOURCE.REC<OFS.SRC.GENERIC.USER>
*    OPERATOR = USER.NAME

    CALL CHANGE.USERS.PROFILE(PROFILE.ARGS)

*    IF NOT(ETEXT) THEN
*        PASSWORD = REQUEST[',', 2, 1]
*        CALL VALIDATE.SIGN.ON(USER.NAME, PASSWORD)          ;* Validates Internet user/password.
*    END

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = ''          ;* Reset back once the user is authenticated.

    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = ACT.SOURCE.TYPE

    IF ETEXT THEN
        GOSUB PROCESS.ERROR
        MOB.ERROR = ETEXT
        ETEXT = ''
    END ELSE
        MOB.RESPONSE = 'SUCCESS'
    END

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.ERROR:
*-------------

    CALL STORE.END.ERROR

    RETURN

*---------------------------------------------------------------------------------------------------

END
