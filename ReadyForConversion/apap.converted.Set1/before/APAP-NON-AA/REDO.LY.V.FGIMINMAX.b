*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.V.FGIMINMAX
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.V.FGIMINMAX
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
*23.11.2011  RMONDRAGON    ODR-2011-06-0243       UPDATE
*24.12.2012  RMONDRAGON    ODR-2011-06-0243       UPDATE
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

  IF Y.FORM.GEN EQ '2' AND Y.GEN.AMT EQ 'Interes' THEN
    GOSUB VAL.FIELD.GEN
    GOSUB VAL.FIELD.MIN
    GOSUB VAL.FIELD.MAX
    GOSUB VAL.BOTH
    COMI = MAX.LIM.PT
  END

  RETURN

*-------------
VAL.FIELD.GEN:
*-------------

  GEN.PT = R.NEW(REDO.MOD.INT.GEN.FACTOR)
  AF = REDO.MOD.INT.GEN.FACTOR
  IF GEN.PT EQ '' THEN
    COMI = ''
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
    CALL STORE.END.ERROR
  END

  VAL.IF.N = GEN.PT
  GOSUB VAL.IF.NUM

  RETURN

*-------------
VAL.FIELD.MIN:
*-------------

  MIN.LIM.PT = R.NEW(REDO.MOD.INT.MIN.GEN)
  AF = REDO.MOD.INT.MIN.GEN
  IF GEN.PT NE '' AND MIN.LIM.PT EQ '' THEN
    COMI = ''
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
    CALL STORE.END.ERROR
  END

  VAL.IF.N = MIN.LIM.PT
  GOSUB VAL.IF.NUM

  RETURN

*-------------
VAL.FIELD.MAX:
*-------------

  MAX.LIM.PT = R.NEW(REDO.MOD.INT.MAX.GEN)
  AF = REDO.MOD.INT.MAX.GEN
  IF GEN.PT NE '' AND MAX.LIM.PT EQ '' THEN
    COMI = ''
    ETEXT = 'EB-REDO.CHECK.FIELDS.F':FM:Y.FORM.GEN
    CALL STORE.END.ERROR
  END

  VAL.IF.N = MAX.LIM.PT
  GOSUB VAL.IF.NUM

  RETURN

*--------
VAL.BOTH:
*--------

  IF MAX.LIM.PT LT MIN.LIM.PT THEN
    AF = REDO.MOD.INT.MAX.GEN
    ETEXT = 'EB-REDO.LY.V.MAX.GEN'
    CALL STORE.END.ERROR
  END

  RETURN

*----------
VAL.IF.NUM:
*----------

  IF NOT(NUM(VAL.IF.N)) THEN
    ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM'
    CALL STORE.END.ERROR
  END

  RETURN

END
