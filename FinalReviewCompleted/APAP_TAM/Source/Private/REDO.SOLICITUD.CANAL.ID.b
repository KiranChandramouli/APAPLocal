* @ValidationCode : Mjo1NjE1OTkyMjQ6Q3AxMjUyOjE2ODEwNTY0ODYxMTk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
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
SUBROUTINE REDO.SOLICITUD.CANAL.ID
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

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
    ID.NEW = TODAY:FMT(ID.NEW,"R%9")

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
