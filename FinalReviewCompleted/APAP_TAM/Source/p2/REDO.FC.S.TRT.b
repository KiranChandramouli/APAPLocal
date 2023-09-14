* @ValidationCode : MjoxNDk0NDYxOTg5OkNwMTI1MjoxNjg0NDkxMDM0MDU0OklUU1M6LTE6LTE6LTQyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -42
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.TRT
* ============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TYPE.RATE.REV
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : OCT 21 2011
*
* Modified by     : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : 03 JAN 2011
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*============================================================================

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_System
******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
*
* =========
OPEN.FILES:
* =========
*

RETURN
*
* =========
INITIALISE:
* =========
*
    Y.TYPE.RATE.REV  = R.NEW (REDO.FC.TYPE.RATE.REV)
    PROCESS.GOAHEAD  = 1
    Y.PAYMT.DAY      = ""
    Y.PAYMT.DAY.TEMP = ""
    Y.MAT.DATE       = ""
    Y.EFFEC.DT       = ""
    Y.COMI           = ""
    Y.MONTH          = 1        ;*R.NEW(REDO.FC.RATE.FQY)[1,1]
    Y.FRQ            = RIGHT(R.NEW(REDO.FC.RATE.FQY),1)
    Y.DAY            = ""
    Y.EF.DAY         = ""
RETURN
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    IF Y.TYPE.RATE.REV NE "PERIODICO" THEN
        PROCESS.GOAHEAD = ""
    END

    IF Y.MONTH[1,1] NE "0"  AND PROCESS.GOAHEAD THEN
        Y.MONTH = "0":Y.MONTH
    END
    IF Y.FRQ NE "M" AND PROCESS.GOAHEAD THEN
        PROCESS.GOAHEAD = ""
        AF = REDO.FC.RATE.FQY
        ETEXT = "EB-FRQ-NOVALID"
        CALL STORE.END.ERROR
    END
    IF  R.NEW(REDO.FC.RATE.FQY) EQ "" AND PROCESS.GOAHEAD THEN
        PROCESS.GOAHEAD = ""
        AF = REDO.FC.RATE.FQY
        ETEXT  = 'EB-FC-MANDOTORY.FIELD'
        CALL STORE.END.ERROR
    END

    IF R.NEW(REDO.FC.FST.RE.DATE) AND R.NEW(REDO.FC.FST.RE.DATE) LE TODAY THEN
        AF = REDO.FC.FST.RE.DATE
        ETEXT  = 'EB-REDO.DATE.LESS.CURR'
        CALL STORE.END.ERROR
        PROCESS.GOAHEAD = ""
    END


RETURN
*
* ======
PROCESS:
* ======
*
    IF  R.NEW(REDO.FC.RATE.FQY) NE "" AND R.NEW(REDO.FC.FST.RE.DATE) EQ '' THEN
        Y.MAT.DATE = R.NEW(REDO.FC.RATE.FQY)
        Y.EFFEC.DT = R.NEW(REDO.FC.EFFECT.DATE)
        CALL CALENDAR.DAY(Y.EFFEC.DT,'+', Y.MAT.DATE)
        R.NEW(REDO.FC.FST.RE.DATE) = Y.MAT.DATE

    END

* Edited for PACS00151814-Instrumento a Plazo
    IF R.NEW(REDO.FC.PAYMT.DAY) NE "" AND R.NEW(REDO.FC.FST.RE.DATE) NE '' THEN

        Y.COMI     = COMI
        Y.EFFEC.DT = R.NEW(REDO.FC.FST.RE.DATE)
        Y.DAY      = R.NEW(REDO.FC.PAYMT.DAY)
        Y.EF.DAT   = SUBSTRINGS (R.NEW(REDO.FC.FST.RE.DATE),1,6)
        Y.EF.DAY    = SUBSTRINGS (R.NEW(REDO.FC.FST.RE.DATE),7,8)
        IF Y.DAY EQ '01' THEN
            Y.MONTH = "00"
        END

* IF Y.DAY LT Y.EF.DAY THEN
*   Y.MONTH = "00"
*END

        COMI       = Y.EF.DAT:"01": "M":Y.MONTH:Y.DAY
        CALL CFQ
        Y.DATE     = COMI[1,8]
        COMI       = Y.COMI
        R.NEW(REDO.FC.FST.RE.DATE) = Y.DATE

    END

    IF R.NEW(REDO.FC.PAYMT.DAY) EQ "" AND R.NEW(REDO.FC.FST.RE.DATE) NE '' THEN
        Y.COMI = COMI
        Y.EFFEC.DT = R.NEW(REDO.FC.FST.RE.DATE)
        Y.EF.DAY   = SUBSTRINGS (R.NEW(REDO.FC.FST.RE.DATE),7,8)
        Y.DAY      = SUBSTRINGS (R.NEW(REDO.FC.EFFECT.DATE),7,8)

        IF Y.DAY LE Y.EF.DAY THEN
            Y.MONTH = "00"
        END
        COMI = Y.EFFEC.DT : "M":Y.MONTH:Y.DAY
        CALL CFQ
        Y.DATE = COMI[1,8]
        COMI = Y.COMI

        R.NEW(REDO.FC.FST.RE.DATE) = Y.DATE
    END
RETURN
END
