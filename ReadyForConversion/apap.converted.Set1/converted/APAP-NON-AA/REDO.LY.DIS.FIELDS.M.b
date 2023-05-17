SUBROUTINE REDO.LY.DIS.FIELDS.M
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.LY.DIS.FIELDS.M
* ODR NO      : ODR-2009-12-0276
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to disable some fields according with the modality
* type to apply for point generation

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*06.04.2010  H GANESH     ODR-2009-12-0276  INITIAL CREATION
*29.07.2011 RMONDRAGON    ODR-2011-06-0243      UPDATE
*21.11.2011 RMONDRAGON    ODR-2011-06-0243      UPDATE
*24.05.2012 RMONDRAGON    ODR-2011-06-0243      UPDATE
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        Y.TYPE = R.NEW(REDO.MOD.TYPE)
    END ELSE
        Y.TYPE = COMI
    END

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF Y.TYPE EQ '1' THEN
        T(REDO.MOD.EVENT)<3> = 'NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        T(REDO.MOD.ANTIG)<3> = 'NOINPUT'
*        R.NEW(REDO.MOD.CURRENCY) = 'DOP'
*        T(REDO.MOD.CURRENCY)<3> = 'NOINPUT'
    END

    IF Y.TYPE EQ '2' OR Y.TYPE EQ '3' OR Y.TYPE EQ '4' OR Y.TYPE EQ '5' OR Y.TYPE EQ '8' THEN
        GOSUB DIS.FIELDS.G1
*        R.NEW(REDO.MOD.FORM.GENERATION)='1'
*        T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
    END

    IF Y.TYPE EQ '6' THEN
        T(REDO.MOD.EX.PROD.AS)<3>='NOINPUT'
*        T(REDO.MOD.CURRENCY)<3>='NOINPUT'
        GOSUB DIS.FIELDS.G2
    END

    IF Y.TYPE EQ '7' THEN
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        T(REDO.MOD.ANTIG)<3>='NOINPUT'
        T(REDO.MOD.CURRENCY)<3>='NOINPUT'
        T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
        GOSUB DIS.FIELDS.G2
    END

*    IF Y.TYPE EQ '8' THEN
*        GOSUB DIS.FIELDS.G1
*    END

RETURN

*-------------
DIS.FIELDS.G1:
*-------------

    T(REDO.MOD.EVENT)<3>='NOINPUT'
    T(REDO.MOD.EX.PROD.AS)<3>='NOINPUT'
    T(REDO.MOD.CHANNEL)<3>='NOINPUT'
    T(REDO.MOD.APP.TXN)<3>='NOINPUT'
    T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
*    T(REDO.MOD.CURRENCY)<3>='NOINPUT'
    T(REDO.MOD.ANTIG)<3>='NOINPUT'

RETURN

*-------------
DIS.FIELDS.G2:
*-------------

    T(REDO.MOD.CHANNEL)<3>='NOINPUT'
    T(REDO.MOD.APP.TXN)<3>='NOINPUT'
    T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
    R.NEW(REDO.MOD.FORM.GENERATION)='1'
    T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
*    T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
    T(REDO.MOD.MIN.DISBURSE.AMT)<3>='NOINPUT'
    T(REDO.MOD.GEN.AMT)<3>='NOINPUT'
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

END
