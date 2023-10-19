* @ValidationCode : MjotODE4NTEwODg1OkNwMTI1MjoxNjgwODg4MzAxOTc5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2023 22:55:01
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.PREGUNTAS.USR.ID
 
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

*-----------------------------------------------------------------------------

    GOSUB INITIALISE

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*V$SEQ = ID.NEW
*IF V$SEQ LT '000000001' OR V$SEQ GT '999999999' THEN
*   E ='Secuencial Invalido'
*   V$ERROR = 1
*   GOSUB FIELD.ERROR
*END

*ID.NEW = TODAY:FMT(ID.NEW,'9"0"R')

* RMONDRAGON - FEB/8/2012 - S
* CORRECTION TO SEE OR MODIFY PREVIOUS RECORDS THAN TODAY
    ID.LENGHT = LEN(ID.NEW)
    IF ID.LENGHT LT 17 THEN
        ID.NEW = TODAY:FMT(ID.NEW,"R%9")
    END
* RMONDRAGON - FEB/8/2012 - E

    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        GOSUB FIELD.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
FIELD.ERROR:
*
    T.SEQU = "IFLD"
    CALL ERR
RETURN

*-----------------------------------------------------------------------------
*
END
