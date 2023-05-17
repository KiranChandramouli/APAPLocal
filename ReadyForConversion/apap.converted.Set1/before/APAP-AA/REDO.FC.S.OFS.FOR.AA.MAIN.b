*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.OFS.FOR.AA.MAIN (ID.PRODUCT, STR.OFS)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.AUTHORISE
* Attached as     : ROUTINE
* Primary Purpose : Build OFS for AA
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 01 Julio 2011
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_F.REDO.APP.MAPPING

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS.MAIN
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*=============
* Por defecto siempre se ejecuta esta parte
*
  STR.OFS = ""
  ID.APP.MAPPING = "AA.ACTIVITY"
  CALL REDO.FC.S.OFS.FOR.AA(ID.APP.MAPPING, STR.OFS)
  TEXTO := STR.OFS

* Segun el producto se ejecuta las propiedades
*
  CALL CACHE.READ(FN.REDO.APP.MAPPING, Y.IDAPP, R.REDO.APP.MAPPING, YERR)
  Y.APLICACION.FROM = R.REDO.APP.MAPPING<REDO.APP.APP.FROM>
  Y.APLICACION.TO = R.REDO.APP.MAPPING<REDO.APP.APP.TO>
  NRO.LINK = DCOUNT(R.REDO.APP.MAPPING<REDO.APP.LINK.TO.RECS>,VM)
  II = 1
  FOR I=1 TO NRO.LINK
    STR.OFS = ""
    ID.APP.MAPPING = R.REDO.APP.MAPPING<REDO.APP.LINK.TO.RECS,I>
    Y.PROPERTY = R.REDO.APP.MAPPING<REDO.APP.ATTRIBUTE,I>
    CALL REDO.FC.S.OFS.FOR.AA.PROPERTY(ID.APP.MAPPING, Y.PROPERTY, II, STR.OFS)
    IF STR.OFS THEN
      TEXTO :=STR.OFS
      II++
    END
  NEXT
  STR.OFS = TEXTO
  RETURN
*------------------------
INITIALISE:
*=========

  FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
  R.REDO.APP.MAPPING  = ''

  Y.IDAPP = "AA-":ID.PRODUCT
  OFS.STR.BODY  = ''
  YERR = ''
  TEXTO = ""
  PROCESS.GOAHEAD = 1
  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
