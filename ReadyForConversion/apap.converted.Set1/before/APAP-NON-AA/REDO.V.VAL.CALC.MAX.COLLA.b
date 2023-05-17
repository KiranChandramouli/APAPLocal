  SUBROUTINE REDO.V.VAL.CALC.MAX.COLLA
*-----------------------------------------------------------------------------
* <Rating>-43</Rating>

*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.CALC.MAX.COLLA
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
$INSERT I_F.REDO.FC.COLL.CODE.PARAMS

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======

*DEBUG
  VAR.VERSION = PGM.VERSION
  Y.COLL.ID = R.NEW(COLL.COLLATERAL.CODE)
  Y.COLL.TYPE.ID = R.NEW(COLL.COLLATERAL.TYPE)

  IF VAR.VERSION MATCHES 'REDO.MODIFICA' THEN
*Get the max % for the Collateral

    CALL F.READ(FN.PARMS,Y.COLL.TYPE.ID,R.PARMS,F.PARMS,ERR.MSJ)
*    VAR.MAX.POR =  R.PARMS<2>
* Tus Start
      VAR.MAX.POR =  R.PARMS<FC.PR.PER.MAX.PRESTAR>
      * Tus End

    IF (VAR.MAX.POR) GT 0   THEN
      R.NEW(COLL.LOCAL.REF)<1,WPOSMAPO> =  VAR.MAX.POR
    END
    ELSE
      AF = COLL.LOCAL.REF
      AV = YPOS<1,4>
      ETEXT = 'ST-REDO.CCRG.MAX.POR.DEF'
      CALL STORE.END.ERROR
    END
  END
* Only for Real States
  IF Y.COLL.ID EQ 450 THEN

*Get the sum for grevamen
    VAR.VAL.GRAV1  = R.NEW(COLL.LOCAL.REF)<1,WPOSVAGR>

    VAR.FILAS    = DCOUNT(VAR.VAL.GRAV1,SM)


    VAR.REGDIRE  = CHANGE(VAR.VAL.GRAV1,SM,FM)

    VAR.SUM = 0

    VAR.I =1
    LOOP
    WHILE VAR.I LE VAR.FILAS
      VAR.REG = VAR.REGDIRE<VAR.I>
      VAR.SUM = VAR.SUM + VAR.REG
      VAR.I+=1
    REPEAT


*SET THE MAX VALUES
    VAR.VAL.GRAV = VAR.SUM
    VAR.POR.MAX   = R.NEW(COLL.LOCAL.REF)<1,WPOSPORP>
    VAR.VAL.TOT   = R.NEW(COLL.LOCAL.REF)<1,WPOSTOVA>

    VAR.VAL.MAXP  = ((VAR.VAL.TOT - VAR.VAL.GRAV) * VAR.POR.MAX ) / 100
    VAR.VAL.MAXP  = DROUND(VAR.VAL.MAXP,2)
    R.NEW(COLL.LOCAL.REF)<1,WPOSVAMA> =  VAR.VAL.MAXP
    R.NEW(COLL.LOCAL.REF)<1,WPOSMAXP> =  VAR.VAL.MAXP

*       *Set the valuea Avaliable
*       R.NEW(COLL.LOCAL.REF)<1,WPOSTODI> =  VAR.VAL.MAXP
*DECOMENTAR CUANO NECESITE EL SALDO DDE LA GARANTIA
* PACS00313341 - S
*        R.NEW(COLL.LOCAL.REF)<1,WPOSTODI> = 0
* PACS00313341 - E
  END
  RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========
  FN.PARMS  = 'F.REDO.FC.COLL.CODE.PARAMS'
  F.PARMS   = ''
  R.PARMS   = ''
  ERR.MSJ   = ''

  PROCESS.GOAHEAD = 1
*Set the local fild for read

  WCAMPO = "L.COL.ENCUM.VAL"
  WCAMPO<2> = "L.COL.LN.MX.PER"
  WCAMPO<3> = "L.COL.LN.MX.VAL"
  WCAMPO<4> = "L.COL.LN.MX.PER"
  WCAMPO<5> = "L.COL.TOT.VALUA"
  WCAMPO<6> = "L.COL.VAL.AVA"
  WCAMPO<7> = "L.COL.LN.MX.VAL"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

  WPOSVAGR  = YPOS<1,1>
  WPOSPORP  = YPOS<1,2>
  WPOSVAMA  = YPOS<1,3>
  WPOSMAPO  = YPOS<1,4>
  WPOSTOVA  = YPOS<1,5>
  WPOSTODI  = YPOS<1,6>
  WPOSMAXP  = YPOS<1,7>

  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.PARMS,F.PARMS)
  RETURN
*------------
END
