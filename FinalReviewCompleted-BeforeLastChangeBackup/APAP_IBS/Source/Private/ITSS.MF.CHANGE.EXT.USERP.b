* @ValidationCode : MjoxOTc3OTMwMzIzOkNwMTI1MjoxNjk4NDA1NTM5MDkxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-54</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.MF.CHANGE.EXT.USERP(ACTION.INFO, REQUEST, MOB.RESPONSE, MOB.ERROR)
        
*---------------------------------------------------------------------------------------------------
* Description :
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
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
    PROFILE.ARGS<2> = 'PROCESS.CHANGE'
    PROFILE.ARGS<3> = REQUEST[',', 1, 1]
    PROFILE.ARGS<4> = REQUEST[',', 2, 1]
    PROFILE.ARGS<5> = REQUEST[',', 3, 1]
    PROFILE.ARGS<6> = EXT.USER.ID

    USER.NAME = EXT.USER.ID
    PASSWORD = REQUEST[',', 1, 1]

RETURN

*---------------------------------------------------------------------------------------------------
CHANGE.PASSWORD:
*---------------

    GOSUB SAVE.COMMON

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = 'INTERNET'  ;* Just tell VSO that we are validating EB.EXTERNAL.USER
    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = 'SESSION'         ;* Just tell VSO that we are validating EB.EXTERNEL.USER

    CALL VALIDATE.SIGN.ON(USER.NAME, PASSWORD)    ;* Validates Internet user/password.

    OPERATOR = OFS$SOURCE.REC<OFS.SRC.GENERIC.USER>
    CALL CHANGE.USERS.PROFILE(PROFILE.ARGS)

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = ''          ;* Reset back once the user is authenticated.

    GOSUB RESTORE.COMMON

    IF ETEXT THEN
        GOSUB PROCESS.ERROR
        MOB.ERROR = ETEXT
        ETEXT = ''
    END ELSE
        MOB.RESPONSE = 'SUCCESS'
    END

RETURN

*---------------------------------------------------------------------------------------------------
SAVE.COMMON:
*-----------

    SAVE.OPERATOR = OPERATOR
    SAVE.R.USER = R.USER
    ACT.SOURCE.TYPE = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>

RETURN

*---------------------------------------------------------------------------------------------------
RESTORE.COMMON:
*--------------

    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = ACT.SOURCE.TYPE
    OPERATOR = SAVE.OPERATOR
    R.USER = SAVE.R.USER

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.ERROR:
*-------------

    CALL STORE.END.ERROR

RETURN

*---------------------------------------------------------------------------------------------------

END
