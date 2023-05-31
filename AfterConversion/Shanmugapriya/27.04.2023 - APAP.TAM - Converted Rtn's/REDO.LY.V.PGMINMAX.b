* @ValidationCode : MjoxNjA5OTI1Njc6Q3AxMjUyOjE2ODEzNzYwOTgwNTg6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:58
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
SUBROUTINE REDO.LY.V.PGMINMAX
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.V.PGMINMAX
* ODR NO      : ODR-2011-06-0243
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to invalidate the NULL values in MAX and MIN fields
* for point generation in case GEN POINTS field is parametrized.

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.07.2011  RMONDRAGON      ODR-2011-06-0243    FIRST VERSION
*18.11.2011  RMONDRAGON      ODR-2011-06-0243       UPDATE
*13.04.2023  Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
*13.04.2023  Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        GOSUB PROCESS
    END

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    Y.FORM.GEN = R.NEW(REDO.MOD.FORM.GENERATION)
    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.GEN.AMT = R.NEW(REDO.MOD.GEN.AMT)

    IF Y.TYPE EQ '6' OR Y.TYPE EQ '7' THEN
        GOSUB VAL.FIELD.GEN
        GOSUB VAL.BY.EVENT.AND.EXPROD
        RETURN
    END

    Y.PRE.VAL = 'N'

    IF Y.GEN.AMT EQ 'Total' OR Y.GEN.AMT EQ 'Capital' OR Y.GEN.AMT EQ '' THEN
        Y.PRE.VAL = 'Y'
    END

    IF Y.FORM.GEN EQ '1' AND Y.PRE.VAL EQ 'Y' THEN
        GOSUB VAL.FIELD.GEN
        GOSUB VAL.FIELD.MIN
        GOSUB VAL.FIELD.MAX
        GOSUB VAL.BOTH
    END

RETURN

*-------------
VAL.FIELD.GEN:
*-------------

    GEN.PT = R.NEW(REDO.MOD.GEN.POINTS)
    AF = REDO.MOD.GEN.POINTS
    IF GEN.PT EQ '' THEN
        COMI = ''
        ETEXT = 'EB-REDO.CHECK.FIELDS.F':@FM:Y.FORM.GEN
        CALL STORE.END.ERROR
    END

    IF NOT(NUM(GEN.PT)) THEN
        ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM'
        CALL STORE.END.ERROR
    END

RETURN

*-------------
VAL.FIELD.MIN:
*-------------

    MIN.LIM.PT = R.NEW(REDO.MOD.LOW.LIM.AMT)
    IF GEN.PT NE '' AND MIN.LIM.PT EQ '' THEN
        COMI = ''
        AF = REDO.MOD.LOW.LIM.AMT
        ETEXT = 'EB-REDO.CHECK.FIELDS.F':@FM:Y.FORM.GEN
        CALL STORE.END.ERROR
    END

RETURN

*-------------
VAL.FIELD.MAX:
*-------------

    MAX.LIM.PT = R.NEW(REDO.MOD.UP.LIM.AMT)
    IF GEN.PT NE '' AND MAX.LIM.PT EQ '' THEN
        COMI = ''
        AF = REDO.MOD.UP.LIM.AMT
        ETEXT = 'EB-REDO.CHECK.FIELDS.F':@FM:Y.FORM.GEN
        CALL STORE.END.ERROR
    END

RETURN

*--------
VAL.BOTH:
*--------

    IF MAX.LIM.PT LT MIN.LIM.PT THEN
        AF = REDO.MOD.UP.LIM.AMT
        ETEXT = 'EB-REDO.LY.V.UP.LIM.AMT'
        CALL STORE.END.ERROR
    END

RETURN

*-----------------------
VAL.BY.EVENT.AND.EXPROD:
*-----------------------

    VAL.CNT = DCOUNT(GEN.PT,@VM)
    IF VAL.CNT GT '1' THEN
        AF = REDO.MOD.GEN.POINTS
        ETEXT = 'EB-REDO.LY.GENPBYEVENT':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN

END
