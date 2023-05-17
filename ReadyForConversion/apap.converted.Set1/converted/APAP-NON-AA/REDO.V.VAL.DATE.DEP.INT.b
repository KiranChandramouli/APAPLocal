SUBROUTINE REDO.V.VAL.DATE.DEP.INT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE.DEP.INT
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

    Y.ACTUAL = R.NEW(COLL.VALUE.DATE)


*Get the values for the local fields Grating Date.  - Fecha de Constitucion
    Y.FEC2 = R.NEW(COLL.LOCAL.REF)<1,WPOSCODA>

    IF LEN(TRIM(Y.FEC2)) GT 0 THEN
* CHECK THE DATE THAT NOT LOWER THAN THE ACTUAL DATE
        IF Y.FEC2 LT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,1>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC2 GT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,1>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END
    END
    ELSE
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'EB-INP.MISS'
        CALL STORE.END.ERROR
    END


*Get the values for the local fields *Executing Date. - Fecha de Formalizacion
    Y.FEC3 = R.NEW(COLL.LOCAL.REF)<1,WPOSFODA>

    IF LEN(TRIM(Y.FEC3)) GT 0 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 LT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,2>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 GT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,2>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END
    END
    ELSE
        AF = COLL.LOCAL.REF
        AV = YPOS<1,2>
        ETEXT = 'EB-INP.MISS'
        CALL STORE.END.ERROR
    END


RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
*Set the local fild for read

    WCAMPO     = "L.COL.GT.DATE"
    WCAMPO<2>  = "L.COL.EXE.DATE"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*Grating Date.   - Fecha de Constitucion
    WPOSCODA  = YPOS<1,1>
*Executing Date. - Fecha de Formalizacion
    WPOSFODA  = YPOS<1,2>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
