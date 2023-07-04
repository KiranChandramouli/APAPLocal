* @ValidationCode : MjotMTU1Nzk4NTQ3MjpDcDEyNTI6MTY4MjUxODg4ODI0MzpJVFNTOi0xOi0xOjEwODY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 19:51:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1086
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     = TO EQ
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   GOTO to GOSUB
*----------------------------------------------------------------------------------------
PROGRAM TESTCALLJ
    packageName = ''
    className = 'Logic.Hash'
    methodName = 'SHA1'
    param = 'S'

    CRT 'calling CALLJ'
    CALLJ packageName : className, methodName, param SETTING returnValue ON ERROR GOSUB errHandler ;* R22 Manual conversion - GOTO to GOSUB
    CRT 'recieved from Java ' : returnValue
RETURN

errHandler:
    CRT 'Error!!'
    ERR = SYSTEM(0)
    BEGIN CASE
        CASE ERR EQ 1 ;*R22 AUTO CONVERSION
            CRT 'JVM releated error'
        CASE ERR EQ 2 ;*R22 AUTO CONVERSION
            CRT 'Cannot find the JVM. Check your environment variables'
        CASE ERR EQ 3 ;*R22 AUTO CONVERSION
            CRT 'Cannot find class ' : className : '. Check your classpath'
        CASE ERR EQ 4 ;*R22 AUTO CONVERSION
            CRT 'Unicode conversion ERROR'
        CASE ERR EQ 5 ;*R22 AUTO CONVERSION
            CRT 'Cannot find method ' : methodName
        CASE ERR EQ 6 ;*R22 AUTO CONVERSION
            CRT 'JVM releated error'
        CASE ERR EQ 8 ;*R22 AUTO CONVERSION
            CRT 'JVM releated error'
        CASE 1  ;* default case
            CRT 'JVM releated error'
    END CASE
END
