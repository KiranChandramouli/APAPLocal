*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.IDGARA.FS

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.IDGARA.FS
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
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

**** FOR VALIDATE INFORMATION OTHER COLLATERALS 06/09/2012***
  IF PGM.VERSION EQ ',REDO.INGRESO.OG' THEN
    IF COMI = '' THEN
      RETURN
    END
  END
**** END VALIDATE INFORMATION



  CALL REDO.V.VAL.ID.GARA


  GUAR.CUS.ID = COMI


  VAR.CUS.ID      = R.NEW(COLL.LOCAL.REF)<1,WPOSLEGID>
  IF GUAR.CUS.ID NE VAR.CUS.ID THEN
    AF = COLL.LOCAL.REF
    AV = ZPOS<1,1>
    ETEXT = 'ST-CLIE-GARA'
    CALL STORE.END.ERROR
  END

  RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  ZPOS= 0

  FN.COLLATERAL   = 'F.COLLATERAL'
  F.COLLATERAL    = ''
  R.COLLATERAL    = ''

  WCAMPO ="L.COL.SEC.HOLD"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,ZPOS)
  WPOSLEGID=ZPOS<1,1>


  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.COLLATERAL,F.COLLATERAL)
  RETURN
*------------
END
