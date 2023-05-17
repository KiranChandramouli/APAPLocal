SUBROUTINE REDO.V.VAL.RAT.DATE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     :
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
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            :
*
*------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======

    Y.RAT.DATE = R.NEW(COLL.LOCAL.REF)<1,WPOS.RAT.DATE>
    Y.ACTUAL.DATE = R.NEW(COLL.VALUE.DATE)


    IF Y.RAT.DATE GT Y.ACTUAL.DATE THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-REDO.COLLA.VALI.DATE'
        CALL STORE.END.ERROR
    END




RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1


*Set the local fild for read
    WCAMPO     = "L.COL.VAL.DATE"
    YPOS=''

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.RAT.DATE  = YPOS<1,1>

RETURN

*------------
END
