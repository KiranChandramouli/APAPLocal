  SUBROUTINE REDO.V.VAL.DATE.BR
*-----------------------------------------------------------------------------
* <Rating>-47</Rating>
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE.BR
* Attached as     : ROUTINE
* Primary Purpose : VERIFY THE DATES USING THE FIELD "FECHA DE CREACION"
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

*USE THE DATE SET BY THE USER "FECHA CREACION" FOR VERIFY THE 2 OTHER DATES
  Y.ACTUAL = R.NEW(COLL.VALUE.DATE)

*Get the values for the local fields (Granting Date)
  Y.FEC2 = R.NEW(COLL.LOCAL.REF)<1,WPOSCODA>

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
  IF Y.FEC2 GT TODAY THEN
    AF = COLL.LOCAL.REF
    AV = YPOS<1,2>
    ETEXT = 'ST-REDO.COLLA.VALI.DATE'
    CALL STORE.END.ERROR
  END

*Get the values for the local fields (Granting Date)
  Y.FEC3 = R.NEW(COLL.LOCAL.REF)<1,WPOSFODA>

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
  IF Y.FEC3 GT TODAY THEN
    AF = COLL.LOCAL.REF
    AV = YPOS<1,3>
    ETEXT = 'ST-REDO.COLLA.VALI.DATE'
    CALL STORE.END.ERROR
  END

***VALIDACIONES DE CAMPOS USANDO OVERRIDES***

*VERIFY THAT EXPIRATION DATE APPRAISAL NOT LESS COLLATERAL DATE
  Y.FEC.VENC.TASA = R.NEW(COLL.LOCAL.REF)<1,WPOSFEVT>

  IF (Y.FEC.VENC.TASA LT Y.ACTUAL) AND ((LEN(TRIM(Y.FEC.VENC.TASA))) GT 0)  THEN
    TEXT = "COLL.FEC.VENC.BR"
    M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
    CALL STORE.OVERRIDE(M.CONT)
  END


***VERIFY VALUE FOR CONSTRUCTION**
  Y.ARE.COSTRUC = R.NEW(COLL.LOCAL.REF)<1,WPOSAREA>
  Y.VAL.CONTRUC = R.NEW(COLL.LOCAL.REF)<1,WPOSVALU>
  Y.YEARS       = R.NEW(COLL.LOCAL.REF)<1,WPOSYEAR>
  Y.POR.DEP     = R.NEW(COLL.LOCAL.REF)<1,WPOSDEPR>
  Y.POR.CONS    = R.NEW(COLL.LOCAL.REF)<1,WPOSPORC>

  IF (LEN(TRIM(Y.ARE.COSTRUC)) GT 0) OR (LEN(TRIM(Y.VAL.CONTRUC)) GT 0) OR (LEN(TRIM(Y.YEARS)) GT 0)  OR (LEN(TRIM(Y.POR.DEP)) GT 0) THEN

    IF (LEN(TRIM(Y.ARE.COSTRUC)) EQ 0 ) THEN
      TEXT = "COLL.AR.COSTRU"
      M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
      CALL STORE.OVERRIDE(M.CONT)
    END

    IF ( LEN(TRIM(Y.VAL.CONTRUC)) EQ 0 ) THEN
      TEXT = "COLL.VAL.COSTRU"
      M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
      CALL STORE.OVERRIDE(M.CONT)
    END

*SI EL ANIO DE CONSTRUCCION ESTA INGRESADO VERIFICA QUE INGRESEN EL PORCENTAJE
    IF (LEN(TRIM(Y.YEARS)) GT 0 ) THEN
      IF (LEN(TRIM(Y.POR.DEP)) EQ 0 ) THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,8>
        ETEXT = 'ST-POR.DEPRE'
        CALL STORE.END.ERROR
      END
    END

    IF (LEN(TRIM(Y.POR.CONS)) EQ 0 ) THEN
      TEXT = "COLL.POR.CONSTRU"
      M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
      CALL STORE.OVERRIDE(M.CONT)
    END

  END


*VERIFICAR FECHA DE TASION
  Y.FECH.TASAC    = R.NEW(COLL.LOCAL.REF)<1,WPOSFETA>
  IF (LEN(TRIM(Y.FECH.TASAC)) EQ 0 ) THEN
    R.NEW(COLL.LOCAL.REF)<1,WPOSFEVT> = ''
    TEXT = "COLL.FECH.TAS"
    M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
    CALL STORE.OVERRIDE(M.CONT)
  END


  RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

  PROCESS.GOAHEAD = 1
*Set the local fild for read

*Fecha de creacion de la garantia
  WCAMPO     = "VALUE.DATE"
*Fecha de constitucion
  WCAMPO<2>  = "L.COL.GT.DATE"
*Fecha de formalizacion de la garantia
  WCAMPO<3>  = "L.COL.EXE.DATE"
*Fecha de vencimiento de tasacion
  WCAMPO<4>  = "L.COL.VA.DUE.DT"
*Construction Area
  WCAMPO<5>  = "L.COL.BLD.AREA"
*M2 VALUE
  WCAMPO<6>  = "L.COL.BLD.VALUE"
*CONSTRUCTION YEARS
  WCAMPO<7>  = "L.COL.YR.BLDING"
*ANNUAL DEPRESIATION
  WCAMPO<8>  = "L.COL.TOTAL.DEP"
*%CONSTRUCTION
  WCAMPO<9>  = "L.P.AVA.CONT"
*FECHA TASACION
  WCAMPO<10> = "L.COL.VAL.DATE"
*FECHA VENCIMIENTO
  WCAMPO<11> = "L.COL.VA.DUE.DT"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

  WPOSVADA  = YPOS<1,1>
  WPOSCODA  = YPOS<1,2>
  WPOSFODA  = YPOS<1,3>
  WPOSFETA  = YPOS<1,4>
  WPOSAREA  = YPOS<1,5>
  WPOSVALU  = YPOS<1,6>
  WPOSYEAR  = YPOS<1,7>
  WPOSDEPR  = YPOS<1,8>
  WPOSPORC  = YPOS<1,9>
  WPOSFETA  = YPOS<1,10>
  WPOSFEVT  = YPOS<1,11>

*CONSTRUCTION VARS
  Y.ARE.COSTRUC = ''
  Y.VAL.CONTRUC = ''
  Y.YEARS       = ''
  Y.POR.DEP     = ''
  Y.POR.CONS    = ''
  Y.FECH.TASAC  = ''
  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
