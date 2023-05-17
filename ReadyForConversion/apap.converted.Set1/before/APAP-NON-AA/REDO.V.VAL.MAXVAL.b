  SUBROUTINE REDO.V.VAL.MAXVAL
*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.MAXVAL
* Attached as     : ROUTINE
* Primary Purpose :
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
*------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN

*-----------------------------------------------------------------------------
PROCESS:
*======
*
*
  IF Y.COL.EXE.VAL GT Y.COL.LN.MXVA THEN
    R.NEW(COLL.MAXIMUM.VALUE) = Y.COL.EXE.VAL
  END
*
  RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
*
*Valor Maximo a Prestar
  WCAMPO     = "L.COL.LN.MX.VAL"
  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0
*
*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*
  WPOSEXED  = YPOS<1,1>

  Y.COL.EXE.VAL = ''
  Y.COL.EXE.VAL = COMI
  Y.COL.LN.MXVA = R.NEW(COLL.LOCAL.REF)<1,WPOSEXED>
*
  RETURN

*---------------------------------------------------------------------------
OPEN.FILES:
*=========

  RETURN
*---------------------------------------------------------------------------
END
