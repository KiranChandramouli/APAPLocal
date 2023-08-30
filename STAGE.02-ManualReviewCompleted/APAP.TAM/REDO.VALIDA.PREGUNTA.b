* @ValidationCode : MjotNjA4OTgyMzM2OkNwMTI1MjoxNjgxODkxMzM3ODA1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:32:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VALIDA.PREGUNTA

******************************************************************

* Validate Fields of REDO.PREGUNTAS.USUARIO Table

* HISTORY
*       AUTHOR.1 - EDGAR GABRIEL RESENDES GONZALEZ
*
*       CLIENT:    APAP

*       DATE:      15/SEP/2010

******************************************************************
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                       <= TO LE,= TO EQ
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.PREGUNTAS.USR

    GOSUB INITIALIZE
RETURN

INITIALIZE:

*** GETS DATA FROM TABLE

    OPENPATH 'C:\' TO MYPATH ELSE NULL

    ID.PREG.USR = ID.NEW

    ID.TIPO.CANAL = R.NEW(RD.PU.TIPO.CANAL)
    PREGUNTA = R.NEW(RD.PU.PREGUNTA)
    RESPUESTA = R.NEW(RD.PU.RESPUESTA)

    CADENA = ID.TIPO.CANAL:" ":PREGUNTA:" ":RESPUESTA
    WRITE CADENA TO MYPATH,'PWDTEST.txt':ID.TIPO.CANAL:PREGUNTA:RESPUESTA ON ERROR NULL


*** VALIDATE INPUT
    STR.LENGTH.CANAL = LEN(ID.TIPO.CANAL)
    STR.LENGTH.PREGUNTA = LEN(PREGUNTA)
    STR.LENGTH.RESPUESTA = LEN(RESPUESTA)

    IF STR.LENGTH.CANAL LE 0 OR ID.TIPO.CANAL EQ "NONE" THEN         ;*R22 AUTO CODE CONVERSION
        E = "EB-VALIDA.CANAL"
        CALL ERR
        RETURN
    END

    IF STR.LENGTH.PREGUNTA LE 0 THEN       ;*R22 AUTO CODE CONVERSION
        E = "EB-VALIDA.PREGUNTA"
        CALL ERR
        RETURN
    END

    IF STR.LENGTH.RESPUESTA LE 0 THEN     ;*R22 AUTO CODE CONVERSION
        E = "EB-VALIDA.RESPUESTA"
        CALL ERR
        RETURN
    END

RETURN

END
