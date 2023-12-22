* @ValidationCode : Mjo3OTY1MjUxNjpVVEYtODoxNzAyNjMxMjE3ODU4OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Dec 2023 14:36:57
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*---------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*24/05/2023                    VIGNESHWARI       MANUAL R22 CODE CONVERSION             NOCHANGE
*24/05/2023                 CONVERSION TOOL     AUTO R22 CODE CONVERSION               NOCHANGE
*15-12-2023                 Narmadha V           Manual R22 Conversion                 Call routine format Modified
*-----------------------------------------------------------------------------------------------------------------------

$PACKAGE APAP.TEST

SUBROUTINE  NEW

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_SCREEN.VARIABLES
    $USING EB.OverrideProcessing
    FOR LL = 0 TO 56
        PRINT @(0,LL):S.CLEAR.EOL:
    NEXT LL

    CALL SF.CLEAR(0,0,"")
    CRT "#################"
    CALL SF.BLINK(0,1," UPGRADE DETAILS ")
    CRT ""
    CRT "#################"
    CRT "                 "

    CRT "Current T24 Release :"
    CALL SF.INPUT(3,16,10)
    INPUT T24.CURR.RELEASE

    CRT "Current jBASE Release :"
    INPUT JB.CURR.RELEASE

    CRT "Upgrade T24 Release to :"
    INPUT T24.NEW.RELEASE

    CRT "Upgrade jBASE Release :"
    INPUT JB.NEW.RELEASE

    CRT "Final Database :"
    CRT "(1 . DB / 2. Oracle / 3. jBase) :"
    INPUT FIN.DB


*CALL DISPLAY.MESSAGE("CHANDRU",2)
    EB.OverrideProcessing.DisplayMessage("CHANDRU",2) ;*Manaul R22 Conversion - Call routine format Modified
    INPUT SOME
END
