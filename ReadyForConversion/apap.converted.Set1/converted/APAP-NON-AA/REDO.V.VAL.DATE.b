SUBROUTINE REDO.V.VAL.DATE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE
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

    Y.ACTUAL = TODAY

*Get the values for the local fields (Granting Date)
    Y.FEC2 = R.NEW(COLL.LOCAL.REF)<1,WPOSCODA>

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
    IF Y.FEC2 GT Y.ACTUAL THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,2>
        ETEXT = 'ST-REDO.COLLA.VALI.DATE'
        CALL STORE.END.ERROR
    END

*Get the values for the local fields (Granting Date)
    Y.FEC3 = R.NEW(COLL.LOCAL.REF)<1,WPOSFODA>

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
    IF Y.FEC3 GT Y.ACTUAL THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,3>
        ETEXT = 'ST-REDO.COLLA.VALI.DATE'
        CALL STORE.END.ERROR
    END


RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
*Set the local fild for read
    WCAMPO     = "VALUE.DATE"
    WCAMPO<2>  = "L.COL.GT.DATE"
    WCAMPO<3>  = "L.COL.EXE.DATE"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOSVADA  = YPOS<1,1>
    WPOSCODA  = YPOS<1,2>
    WPOSFODA  = YPOS<1,3>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
