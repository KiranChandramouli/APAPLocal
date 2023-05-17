*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.COPY.FEC

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.COPY.FEC
* Attached as     : ROUTINE
* Primary Purpose : Copy information from DATE CREATION FOR CONSTITUTION DATE
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : 18/01/2012
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END


  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  R.NEW(COLL.LOCAL.REF)<1,WPOSFECH> = COMI

  RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
*Set the local fild for read
  WCAMPO  = "L.COL.GT.DATE"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

  WPOSFECH  = YPOS<1,1>

  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
