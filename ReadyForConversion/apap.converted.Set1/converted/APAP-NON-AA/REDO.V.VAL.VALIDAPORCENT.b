SUBROUTINE REDO.V.VAL.VALIDAPORCENT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.VALIDAPORCENT
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
    Y.VALOR =  R.NEW(COLL.LOCAL.REF)<1,WPOSPOAV>

    IF Y.VALOR GT 100 THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-REDO.COLLA.VAL.POR.MAX'
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

*Create the array wcampo
    WCAMPO = "L.P.AVA.CONT"
    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOSPOAV  = YPOS<1,1>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
