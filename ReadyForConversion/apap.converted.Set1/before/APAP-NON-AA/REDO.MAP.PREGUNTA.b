*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MAP.PREGUNTA
*-----------------------------------------------------------------------------
* This subroutine will validate that updated question is not duplicated.
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 16th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PREGUNTAS.USR
$INSERT I_F.REDO.PREGUNTAS

  GOSUB INITIALIZE
  GOSUB PROCESS
  RETURN

INITIALIZE:

  FN.REDO.PREGUNTAS.USR='F.REDO.PREGUNTAS.USR'
  F.REDO.PREGUNTAS.USR=''
  CALL OPF(FN.REDO.PREGUNTAS.USR,F.REDO.PREGUNTAS.USR)

  FN.REDO.PREGUNTAS='F.REDO.PREGUNTAS'
  F.REDO.PREGUNTAS=''
  CALL OPF(FN.REDO.PREGUNTAS,F.REDO.PREGUNTAS)

  ID.PREG.USR = ID.NEW
  ID.USR = R.NEW(RD.PU.ID.USUARIO)
  ID.TIPO.CANAL = R.NEW(RD.PU.TIPO.CANAL)
  PREGUNTA = R.NEW(RD.PU.PREGUNTA)
  RESPUESTA = R.NEW(RD.PU.RESPUESTA)

  RETURN

PROCESS:

  AF.PREV = AF

  AF = RD.PU.PREGUNTA

  SEL.CMD='SELECT ':FN.REDO.PREGUNTAS:" WITH PREGUNTA EQ '":PREGUNTA:"'"
  Y.NO.OF.RECS = 0
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',Y.NO.OF.RECS,SEL.RET)
  IF Y.NO.OF.RECS EQ 0 THEN
    ETEXT = "EB-VALIDA.RESPUESTA"
    CALL STORE.END.ERROR
    RETURN
  END

  R.NEW(RD.PU.PREGUNTA) = SEL.LIST<1>
  PREGUNTA.STR = PREGUNTA
  PREGUNTA = SEL.LIST<1>

  SEL.CMD='SELECT ':FN.REDO.PREGUNTAS.USR:' WITH ID.USUARIO EQ ':ID.USR:' AND TIPO.CANAL EQ ':ID.TIPO.CANAL:' AND PREGUNTA EQ ':PREGUNTA:' AND @ID NE ':ID.PREG.USR
  Y.NO.OF.RECS = 0
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',Y.NO.OF.RECS,SEL.RET)
  IF Y.NO.OF.RECS NE 0 THEN
    R.NEW(RD.PU.PREGUNTA) = PREGUNTA.STR
    ETEXT = "EB-VALIDA.RESPUESTA"
    CALL STORE.END.ERROR
    RETURN
  END

  AF = AF.PREV
  RETURN
END
