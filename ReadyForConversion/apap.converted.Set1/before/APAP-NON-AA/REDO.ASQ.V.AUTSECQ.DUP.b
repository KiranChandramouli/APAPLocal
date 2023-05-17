*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ASQ.V.AUTSECQ.DUP
**
* Subroutine Type : VERSION
* Attached to     : REDO.PREGUNTAS,NUEVO
* Attached as     : Field PREGUNTA as VALIDATION.RTN
* Primary Purpose : Validate if question is duplicated.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 31/01/13 - First Version
*            ODR Reference: ODR-2010-06-0075
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PREGUNTAS

  GOSUB INIT
  GOSUB PROCESS

  RETURN

*----
INIT:
*----

  FN.REDO.PREGUNTAS = 'F.REDO.PREGUNTAS'

  RETURN

*-------
PROCESS:
*-------

  Y.QUESTION = R.NEW(RD.PS.PREGUNTA)

  SEL.CMD = 'SELECT ':FN.REDO.PREGUNTAS:' WITH PREGUNTA LIKE "':Y.QUESTION:'"'

  SEL.CMD.ERR = ''
  CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',ID.CNT,SEL.CMD.ERR)

  IF ID.CNT GE 1 THEN
    AF = RD.PS.PREGUNTA
    ETEXT = 'EB-REDO.ASQ.V.AUTSECQ.DUP'
    CALL STORE.END.ERROR
  END

  RETURN

END
