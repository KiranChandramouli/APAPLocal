* @ValidationCode : MjozMjU3MzA5NDc6Q3AxMjUyOjE2ODQ4NTQwNTE0OTA6SVRTUzotMTotMTotMzoxOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.AT.CATCH.REQUEST(ACTUAL.REQUEST)

*--------------------------------------------
* By JP
*-------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 11-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion     CALL routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.REDOSRTN

    AUXREQUEST = ACTUAL.REQUEST
    USERINFO = FIELD(AUXREQUEST,',',3)

    PASSUSER = FIELD(USERINFO,'/',2)
    SIGNONUSER = FIELD(USERINFO,'/',1)

    NEWPASSUSER = SIGNONUSER
*APAP.REDOSRTN.REDO.S.GET.PASS(NEWPASSUSER);*Manual R22 conversion
    APAP.REDOSRTN.redoSGetPass(NEWPASSUSER);*Manual R22 conversion

    IF NEWPASSUSER THEN
        CHANGE PASSUSER TO NEWPASSUSER IN AUXREQUEST
        ACTUAL.REQUEST = AUXREQUEST
    END


RETURN
END
