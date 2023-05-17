SUBROUTINE REDO.V.VAL.SET.CODGARA

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.SET.CODGARA
* Attached as     : ROUTINE
* Primary Purpose : COPI INFORMATION OF ID CLIENTE
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

    CALL REDO.V.VAL.ID.GARA
    R.NEW(COLL.LOCAL.REF)<1,WPOSCOD>= COMI

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    ZPOS = 0

    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''


    WCAMPO ="L.COL.GUAR.ID"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,ZPOS)
    WPOSCOD=ZPOS<1,1>

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*------------
END
