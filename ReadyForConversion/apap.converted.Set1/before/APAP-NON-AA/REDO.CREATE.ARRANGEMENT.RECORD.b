* Version 9 16/05/01  GLOBUS Release No. 200511 31/10/05
*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CREATE.ARRANGEMENT.RECORD
*----------------------------------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : Set default values
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
* Date            : 08 Junio 2011
*
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON


* Check if the record is okay to input to
  GOSUB CHECK.RECORD
  IF E = '' THEN
    GOSUB SET.ENRICHMENTS
    GOSUB INITIALIZE
    GOSUB POPULATE.COMMONS
  END

  RETURN
*-----------------------------------------------------------------------
POPULATE.COMMONS:

  CALL REDO.FC.S.POPVALUES(ID.PARAMS)
  RETURN
*-----------------------------------------------------------------------------
INITIALIZE:

  ID.PARAMS = "SYSTEM"

  RETURN
*-----------------------------------------------------------------------------
SET.ENRICHMENTS:
*      CALL EB.SET.FIELD.ENRICHMENT(FIELD.NUMBER, FIELD.ENRICHMENT)
  RETURN
*--------------------------------------------------------------------
CHECK.RECORD:

  Y.FIRST.TIME = ''
*   IF OFS$BROWSER EQ 1 THEN
  IF OFS$GETRECORD EQ 1 THEN  ;* OFS$GETRECORD is 1, when the application was called for first time
    Y.FIRST.TIME = 1
  END
*   END

  RETURN
*-----------------------------------------------------------------------------
END
