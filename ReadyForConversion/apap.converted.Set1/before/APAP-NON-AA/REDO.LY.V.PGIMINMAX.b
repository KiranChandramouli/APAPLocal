*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.V.PGIMINMAX
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.V.PGIMINMAX
* ODR NO      : ODR-2011-06-0243
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to invalidate the NULL values in MAX and MIN fields
* for point generation in case INTEREST GEN POINTS field is parametrized.

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.07.2011  RMONDRAGON    ODR-2011-06-0243    FIRST VERSION
*18.11.2011  RMONDRAGON    ODR-2011-06-0243       UPDATE
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
  Y.GEN.AMT = R.NEW(REDO.MOD.GEN.AMT)

  IF Y.FORM.GEN EQ '1' AND Y.GEN.AMT EQ 'Interes' THEN
    GOSUB VAL.FIELD.GEN
    GOSUB VAL.FIELD.MIN
    GOSUB VAL.FIELD.MAX
    GOSUB VAL.BOTH
  END

  RETURN

*-------------
VAL.FIELD.GEN:
*-------------

  GEN.PT = R.NEW(REDO.MOD.INT.GEN.POINTS)
  AF = REDO.MOD.INT.GEN.POINTS
  IF GEN.PT EQ '' THEN
    COMI = ''
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
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

  MIN.LIM.PT = R.NEW(REDO.MOD.INT.LOW.LIM.AMT)
  IF GEN.PT NE '' AND MIN.LIM.PT EQ '' THEN
    COMI = ''
    AF = REDO.MOD.INT.LOW.LIM.AMT
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
    CALL STORE.END.ERROR
  END

  RETURN

*-------------
VAL.FIELD.MAX:
*-------------

  MAX.LIM.PT = R.NEW(REDO.MOD.INT.UP.LIM.AMT)
  IF GEN.PT NE '' AND MAX.LIM.PT EQ '' THEN
    COMI = ''
    AF = REDO.MOD.INT.UP.LIM.AMT
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
    CALL STORE.END.ERROR
  END

  RETURN

*--------
VAL.BOTH:
*--------

  IF MAX.LIM.PT LT MIN.LIM.PT THEN
    AF = REDO.MOD.INT.UP.LIM.AMT
    ETEXT = 'EB-REDO.LY.V.UP.LIM.AMT'
    CALL STORE.END.ERROR
  END

  RETURN

END
