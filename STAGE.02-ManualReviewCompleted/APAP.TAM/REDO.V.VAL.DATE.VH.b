$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.DATE.VH
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE.VH
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
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM, VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
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

*VECHICLES ACEPTS BLANC FIELDS FOR DATE
    IF LEN(TRIM(Y.FEC2)) GT 0 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC2 GT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,2>
            ETEXT = 'ST-REDO.COLLA.VALI.DATE'
            CALL STORE.END.ERROR
        END
    END


*Get the values for the local fields (Granting Date)
    Y.FEC3 = R.NEW(COLL.LOCAL.REF)<1,WPOSFODA>

*VECHICLES ACEPTS BLANC FIELDS FOR THE DATE
    IF LEN(TRIM(Y.FEC3)) GT 0 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 GT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,3>
            ETEXT = 'ST-REDO.COLLA.VALI.DATE'
            CALL STORE.END.ERROR
        END
    END
*
RETURN
*------------------------------------------------------------------------
*

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

    WCAMPO = CHANGE(WCAMPO,@FM,@VM) ;*R22 AUTO CONVERSION
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
