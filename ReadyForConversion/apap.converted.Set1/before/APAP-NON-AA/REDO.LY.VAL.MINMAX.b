*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.VAL.MINMAX
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.VAL.MINMAX
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
*13.07.2011  RMONDRAGON    ODR-2011-06-0243    FIRST VERSION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.MODALITY

  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  Y.FORM.GEN = R.NEW(REDO.MOD.FORM.GENERATION)

  IF Y.FORM.GEN EQ '1' THEN
    GEN.PT = R.NEW(REDO.MOD.GEN.POINTS)
    GOSUB VAL.FIELD.MIN
  END

  RETURN

*-------------
VAL.FIELD.MIN:
*-------------

  MIN.LIM.PT = R.NEW(REDO.MOD.LOW.LIM.AMT)
  IF GEN.PT NE '' AND MIN.LIM.PT EQ '' THEN
    AF = REDO.MOD.LOW.LIM.AMT
    ETEXT = 'EB-REDO.LY.LIMGMAXMIN'
    CALL STORE.END.ERROR
  END
  GOSUB VAL.FIELD.MAX

  RETURN

*-------------
VAL.FIELD.MAX:
*-------------

  MAX.LIM.PT = R.NEW(REDO.MOD.UP.LIM.AMT)
  IF GEN.PT NE '' AND MAX.LIM.PT EQ '' THEN
    AF = REDO.MOD.UP.LIM.AMT
    ETEXT = 'EB-REDO.LY.LIMGMAXMIN'
    CALL STORE.END.ERROR
  END

  RETURN

END
