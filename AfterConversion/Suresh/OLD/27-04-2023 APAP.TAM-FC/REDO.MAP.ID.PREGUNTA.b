$PACKAGE APAP.TAM
SUBROUTINE REDO.MAP.ID.PREGUNTA
*-----------------------------------------------------------------------------
* This subroutine will transfor Preguntas id in Pregunta field
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 16th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.PREGUNTAS
    $INSERT I_F.REDO.PREGUNTAS.USR

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

INITIALIZE:

    FN.REDO.PREGUNTAS='F.REDO.PREGUNTAS'
    F.REDO.PREGUNTAS=''
    CALL OPF(FN.REDO.PREGUNTAS,F.REDO.PREGUNTAS)

RETURN

PROCESS:

    CALL F.READ(FN.REDO.PREGUNTAS,COMI,R.PREGUNTA,F.REDO.PREGUNTAS,YERR)
*R.NEW(RD.PU.PREGUNTA) = R.PREGUNTA<1>        ;*TUS START
    R.NEW(RD.PU.PREGUNTA) = R.PREGUNTA<RD.PS.PREGUNTA>        ;*TUS END

RETURN
END
