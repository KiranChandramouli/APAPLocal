  SUBROUTINE REDO.V.REDO.V.VAL.MAX.TOTAL
*-----------------------------------------------------------------------------
* <Rating>-49</Rating>
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.MAX.TOTAL
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
*------------------------------------------------------------------------------

PROCESS:
*======
*Get the max % for the Collateral
  Y.COLL.ID = R.NEW(COLL.COLLATERAL.CODE)

* GET THEN MAX % SET IN THE COLLATERAL
  VAR.POR.MAX = R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PORC>


  IF (VAR.POR.MAX EQ '') OR (VAR.POR.MAX EQ 0 ) THEN
    AF = COLL.LOCAL.REF
    AV = YPOS<1,1>
    ETEXT = 'ST-REDO.COLLA.NOT.DEF.MAX.POR'
    CALL STORE.END.ERROR
  END


* FOR INTERNAL DEPOSITS
  IF Y.COLL.ID = 150 THEN
*Calculate the maximum value for collateral
    VAR.VAL.DISPO  = R.NEW(COLL.LOCAL.REF)<1,WPOS.DISPO.INST>

    VAR.VAL.MAXP  = DROUND( (VAR.VAL.DISPO * VAR.POR.MAX)/100, 2)
    R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> =  VAR.VAL.MAXP

    R.NEW(COLL.MAXIMUM.VALUE)   = VAR.VAL.DISPO
*       R.NEW(COLL.EXECUTION.VALUE) =  VAR.VAL.MAXP

    VAR.NOMINAL = R.NEW(COLL.NOMINAL.VALUE)

*Verify that the value for nominal values not set
*      IF LEN(VAR.NOMINAL)EQ 0 THEN
*         R.NEW(COLL.NOMINAL.VALUE)   = VAR.VAL.DISPO
*      END
  END


  RETURN
*------------------------------------------------------------------------
INITIALISE:
*=========

  PROCESS.GOAHEAD = 1
*Set the local fild for read
  WCAMPO    = "L.COL.LN.MX.PER"         ;* MAX %
  WCAMPO<2> = "L.COL.VAL.AVA" ;* AVALIABLE AMOUNT FOR INTERNAL DEPOSITS
  WCAMPO<3> = "L.COL.LN.MX.VAL"         ;* MAX AMOUNT VALUE
  WCAMPO<4> = "L.AVA.AMO.INS" ;* MONTO DISPONIBLE DEL INSTRUMENTO

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

  WPOS.MAX.PORC     = YPOS<1,1>         ;* MAX %
  WPOS.DISPO.INSTRU = YPOS<1,2>         ;* AVALIABLE AMOUNT FOR INTERNAL DEPOSITS
  WPOS.MAX.VALUE    = YPOS<1,3>         ;* MAX AMOUNT VALUE
  WPOS.DISPO.INST   = YPOS<1,4>         ;* MONTO DISPONIBLE DEL INSTRUMENTO

  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
