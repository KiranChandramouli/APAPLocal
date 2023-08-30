* @ValidationCode : Mjo3MTkwMTYwNTM6Q3AxMjUyOjE2OTI2OTEwOTIyMTQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Aug 2023 13:28:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.CH.A.USERPINCHG
**
* Subroutine Type : VERSION
* Attached to     : REDO.CH.PINADM,RESET.PIN
* Attached as     : AUTHORIZATION.ROUTINE
* Primary Purpose : Display the new PIN number assigned during change
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 8/01/13 - First Version
*           ODR Reference: ODR-2010-06-0155
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*
* 04-APR-2023     Conversion tool    R22 Auto conversion      REM to DISPLAY.MESSAGE(TEXT, '')
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CH.PINADM
    $INSERT I_REDO.CH.V.USERPINCHG.COMMON
    $INSERT JBC.h   ;*R22 Manual Code Conversion
*PIN Generation
    PINMAIL = RND(9) : RND(9) : RND(9) : RND(9)
    PIN = PINMAIL
    PIN.AS = PIN

*PIN Encription
*    KEYUSED = "7"
*    PIN = ENCRYPT(PIN,KEYUSED,JBASE_CRYPT_3DES)
*    PIN = ENCRYPT(PIN,KEYUSED,2)

    KEYUSED = "12345678" ;*R22 Manual Code Conversion
    PIN = ENCRYPT(PIN,KEYUSED,JBASE_CRYPT_DES_BASE64) ;*R22 Manual Code Conversion

    R.NEW(REDO.CH.PINADMIN.PIN) = PIN

    TEXT = "Nuevo PIN temporal asignado: ": PIN.AS
    CALL DISPLAY.MESSAGE(TEXT, '');*R22 Auto conversion

RETURN

END
