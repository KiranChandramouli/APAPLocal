* @ValidationCode : MjoxNDAxMTM3OTQ0OkNwMTI1MjoxNjg2Njc1MjM2NTM3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:23:56
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
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.CH.NEWPWD
**
* Subroutine Type : VERSION
* Attached to     : PASSWORD.RESET,REDO.CH.RESUSRPWD
* Attached as     : USER.PASSWORD field as AUTO.NEW.CONTENT
* Primary Purpose : Generate a new temporal password for Internet User.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version.
*           ODR Reference: ODR-2010-06-0155.
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*           Martin Macias.
*           mmacias@temenos.com
* 07/11/11 - Fix for PACS00146411.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com

*
* Date             Who                   Reference      Description
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - x TO x.VAR, = TO EQ, CHAR TO CHARX
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   - RANDOMIZE() TO RDN()
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.PASSWORD.RESET
    $INSERT I_REDO.CH.NEWPWD.COMMON

    GOSUB CREATE.PWD

RETURN

***********
CREATE.PWD:
***********

    PWD = ""
*RANDOMIZE (TIME())
    RND (TIME())   ;*R22 MANUAL
    FOR x.VAR = 1 TO 8                  ;** R22 Auto conversion - x TO x.VAR
        CharType = RND(3)         ;* Determines whether an uppercase, lowercase or number will be generated next
        BEGIN CASE
            CASE CharType EQ 0; PWD:= CHARX(RND(26) + 65)   ;* Uppercase char      ;** R22 Auto conversion - START
            CASE CharType EQ 1; PWD:= CHARX(RND(26) + 97)   ;* Lowercase char
            CASE CharType EQ 2; PWD:= RND(10)                                    ;** R22 Auto conversion - END
        END CASE
    NEXT x.VAR             ;** R22 Auto conversion - x TO x.VAR

    PASS = PWD
    R.NEW(EB.PWR.USER.PASSWORD) = PWD
    CALL System.setVariable('CURRENT.ARC.PASS',PWD)

RETURN

END
