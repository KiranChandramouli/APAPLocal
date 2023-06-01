* @ValidationCode : MjotNjYwNjUwMzc6Q3AxMjUyOjE2ODM4OTI2Njc2NDQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.DIS.FIELDS.MOD1
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SUDHARSANAN S
* PROGRAM NAME: REDO.LY.DIS.FIELDS.MOD1
* ODR NO      : ODR-2009-12-0276
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to disable some fields according with the modality
* TYPE, FORM.GENERATION AND PRODUCT.GROUP to apply for point generation
 
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*28.02.2011  SUDHARSANAN S
*27.07.2011  RMONDRAGON    ODR-2011-06-0243  Redefinition for Point Generation for C/I
*30.11.2011  RMONDRAGON    ODR-2011-06-0243        Update
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        Y.GEN.AMT = R.NEW(REDO.MOD.GEN.AMT)
    END ELSE
        Y.GEN.AMT = COMI
    END

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
* This main para is used to disable the fields based on PRODUCT.GROUP field

    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.FORM.GEN = R.NEW(REDO.MOD.FORM.GENERATION)

    GOSUB VAL.FIELD

    IF Y.TYPE EQ '1' AND Y.FORM.GEN EQ '1' THEN
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'
        T(REDO.MOD.ANTIG)<3> = 'NOINPUT'
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        GOSUB CHECK.POINTS
    END

    IF Y.TYPE EQ '1' AND Y.FORM.GEN EQ '2' THEN
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'
        T(REDO.MOD.ANTIG)<3> = 'NOINPUT'
        T(REDO.MOD.GEN.POINTS)<3> = 'NOINPUT'
        T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.UP.LIM.AMT)<3> = 'NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        GOSUB CHECK.FACTOR
    END

    IF Y.TYPE EQ '2' AND Y.FORM.GEN EQ '1' THEN
        GOSUB DIS.PREV.FIELDS
        GOSUB CHECK.POINTS
    END

    IF Y.TYPE EQ '2' AND Y.FORM.GEN EQ '2' THEN
        GOSUB DIS.PREV.FIELDS
        GOSUB CHECK.FACTOR
    END

RETURN

*---------
VAL.FIELD:
*---------

    IF Y.TYPE EQ '6' OR Y.TYPE EQ '7' THEN
        RETURN
    END

    IF Y.GEN.AMT EQ '' THEN
        AF = REDO.MOD.GEN.AMT
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN

*---------------
DIS.PREV.FIELDS:
*---------------

    T(REDO.MOD.EVENT)<3> = 'NOINPUT'
    T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
    T(REDO.MOD.CHANNEL)<3> = 'NOINPUT'
    T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'
    T(REDO.MOD.TXN.CODE)<3> = 'NOINPUT'
    T(REDO.MOD.CURRENCY)<3> = 'NOINPUT'
    T(REDO.MOD.ANTIG)<3> = 'NOINPUT'

RETURN

*--------------
CHECK.POINTS:
*--------------
*This para is used to disable the fields based on GENERATION AMOUNT, TYPE & FORM.GENERATION values
    IF Y.GEN.AMT EQ 'Capital' OR Y.GEN.AMT EQ 'Total' THEN
        T(REDO.MOD.GEN.POINTS)<3>=''
        T(REDO.MOD.LOW.LIM.AMT)<3>=''
        T(REDO.MOD.UP.LIM.AMT)<3>=''
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
    END

    IF Y.GEN.AMT EQ 'Interes' THEN
        T(REDO.MOD.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>=''
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>=''
        T(REDO.MOD.INT.UP.LIM.AMT)<3>=''
    END

RETURN

*-------------
CHECK.FACTOR:
*-------------
*This para is used to disable the fields based on GENERATION AMOUNT, TYPE & FORM.GENERATION values

    IF Y.GEN.AMT EQ 'Capital' OR Y.GEN.AMT EQ 'Total' THEN
        T(REDO.MOD.GEN.FACTOR)<3>=''
        T(REDO.MOD.MIN.GEN)<3>=''
        T(REDO.MOD.MAX.GEN)<3>=''
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
    END

    IF Y.GEN.AMT EQ 'Interes' THEN
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>=''
        T(REDO.MOD.INT.MIN.GEN)<3>=''
        T(REDO.MOD.INT.MAX.GEN)<3>=''
    END

RETURN

END
