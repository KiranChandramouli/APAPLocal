* @ValidationCode : MjoxMTkzNjQ2NjAzOkNwMTI1MjoxNjgxNzMzNjg2MTk0OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:44:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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

    AUXREQUEST = ACTUAL.REQUEST
    USERINFO = FIELD(AUXREQUEST,',',3)

    PASSUSER = FIELD(USERINFO,'/',2)
    SIGNONUSER = FIELD(USERINFO,'/',1)

    NEWPASSUSER = SIGNONUSER
    CALL APAP.SRTN.REDO.S.GET.PASS(NEWPASSUSER);*Manual R22 conversion

    IF NEWPASSUSER THEN
        CHANGE PASSUSER TO NEWPASSUSER IN AUXREQUEST
        ACTUAL.REQUEST = AUXREQUEST
    END


RETURN
END
