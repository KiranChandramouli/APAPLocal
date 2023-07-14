* @ValidationCode : MjozMjU3MzA5NDc6Q3AxMjUyOjE2ODM1MzE1NTA0OTE6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 May 2023 13:09:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
*CALL APAP.REDOSRTN.REDO.S.GET.PASS(NEWPASSUSER);*Manual R22 conversion
    CALL APAP.REDOSRTN.redoSGetPass(NEWPASSUSER);*Manual R22 conversion

    IF NEWPASSUSER THEN
        CHANGE PASSUSER TO NEWPASSUSER IN AUXREQUEST
        ACTUAL.REQUEST = AUXREQUEST
    END


RETURN
END
