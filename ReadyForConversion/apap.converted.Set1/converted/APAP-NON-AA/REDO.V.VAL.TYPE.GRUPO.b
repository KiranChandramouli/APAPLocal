SUBROUTINE REDO.V.VAL.TYPE.GRUPO
*
* Subroutine Type : ROUTINE
* Attached to     : REVO.V.VAL.TYPE.GRUPO
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
    VAR.ENTIDAD = R.NEW(COLL.LOCAL.REF)<1,WPOS.ENTITY>
    VAR.TIPO    = R.NEW(COLL.LOCAL.REF)<1,WPOS.TYPE>

    VAR.AUX   = LEFT(VAR.TIPO,2)

    IF VAR.ENTIDAD NE VAR.AUX THEN
*TEXT = "COLL.TYPE.GRUPO"
*M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
*CALL STORE.OVERRIDE(M.CONT)
        AF = COLL.LOCAL.REF
        AV = YPOS<1,2>
        ETEXT = 'ST-COLL.TYPE.GRUPO'
        CALL STORE.END.ERROR

    END

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''

******DEFINICION DE CAMPOS LOCALES ******
    PROCESS.GOAHEAD = 1
*Set the local fild for read
    WCAMPO     = "L.COL.ISS.ENTY"
    WCAMPO<2>  = "L.COL.INVST.TYE"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.ENTITY  = YPOS<1,1>
    WPOS.TYPE    = YPOS<1,2>

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*------------
END
