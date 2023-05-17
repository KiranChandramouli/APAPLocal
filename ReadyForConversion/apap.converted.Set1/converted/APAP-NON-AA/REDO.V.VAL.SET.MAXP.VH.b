SUBROUTINE REDO.V.VAL.SET.MAXP.VH
*
* ===================================================================================
*
* - Set information for "MAXIMO A PRESTAR" according with " % MAXIMO A PRESTAR "
*
*
* ===================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : Set computed values for collateral VH
*
* Incoming:
* ---------
*
* Outgoing:
*
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Pablo Castillo De La Rosa RTam
* Date            : 08/FEB/2012
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_GTS.COMMON
*
*************************************************************************

    GOSUB INITIALISE

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

* =========
PROCESS:
* =========
*EXCECUTE ONLY IF PRESS HOT FIELD
    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END
*
    IF VAR.PORC GT 0 THEN
        VAR.MAXIMO = (Y.NOMINAL.VALUE * VAR.PORC)/100
        VAR.MAXIMO = DROUND(VAR.MAXIMO,2)
        R.NEW(COLL.LOCAL.REF)<1,WPOSMAX> = VAR.MAXIMO
    END
*
RETURN

* =========
INITIALISE:
* =========

    PROCESS.GOAHEAD = 1

    WCAMPO = "L.COL.LN.MX.PER"
    WCAMPO<2> = "L.COL.LN.MX.VAL"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOSPORC   = YPOS<1,1>
    WPOSMAX    = YPOS<1,2>

    VAR.MAXIMO = ''
    Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE)
    VAR.PORC = COMI

RETURN

END
