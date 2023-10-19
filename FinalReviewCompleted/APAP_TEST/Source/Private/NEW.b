* @ValidationCode : MjoxMjc1MDU4MTY5OkNwMTI1MjoxNjg1OTUyMTY0NzY2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:32:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*---------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*24/05/2023                    VIGNESHWARI       MANUAL R22 CODE CONVERSION             NOCHANGE
*24/05/2023                 CONVERSION TOOL     AUTO R22 CODE CONVERSION               NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------

$PACKAGE APAP.TEST

SUBROUTINE NEW

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_SCREEN.VARIABLES

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


    CALL DISPLAY.MESSAGE("CHANDRU",2)
    INPUT SOME
END
