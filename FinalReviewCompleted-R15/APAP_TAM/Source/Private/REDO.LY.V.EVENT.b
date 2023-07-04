* @ValidationCode : MjotMzU3MTE1ODYyOkNwMTI1MjoxNjgyNTI4NDYzMzc4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:03
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
SUBROUTINE  REDO.LY.V.EVENT
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to enable product group field based on the event when modality
*              by event is used in the REDO.LY.MODALITY table
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.EVENT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*27.07.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*14.12.2011    RMONDRAGON         ODR-2011-06-0243     UPDATE
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        Y.EVENT = R.NEW(REDO.MOD.EVENT)
        GOSUB VAL.EVENT
    END ELSE
        Y.EVENT = COMI
        GOSUB PROCESS
    END

RETURN

*-------
PROCESS:
*-------

    IF Y.EVENT NE '' AND Y.EVENT NE '5' THEN
        T(REDO.MOD.ANTIG)<3> = 'NOINPUT'
    END

*    IF Y.EVENT NE '' AND Y.EVENT EQ '4' OR Y.EVENT EQ '5' THEN
*        T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
*    END

    GOSUB DIS.FIELDS

RETURN

*----------
DIS.FIELDS:
*----------

    T(REDO.MOD.EX.PROD.AS)<3>='NOINPUT'
    T(REDO.MOD.CHANNEL)<3>='NOINPUT'
    T(REDO.MOD.APP.TXN)<3>='NOINPUT'
    T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
*    T(REDO.MOD.CURRENCY)<3>='NOINPUT'
    T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
*    T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
    T(REDO.MOD.GEN.AMT)<3>='NOINPUT'
    T(REDO.MOD.MIN.DISBURSE.AMT)<3>='NOINPUT'
    T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
    T(REDO.MOD.UP.LIM.AMT)<3>='NOINPUT'
    T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
    T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
    T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
    T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
    T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
    T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
    T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
    T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
    T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'

RETURN

*---------
VAL.EVENT:
*---------

    Y.TYPE = R.NEW(REDO.MOD.TYPE)

    IF Y.TYPE EQ '6' AND Y.EVENT EQ '' THEN
        AF = REDO.MOD.EVENT
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN

END
