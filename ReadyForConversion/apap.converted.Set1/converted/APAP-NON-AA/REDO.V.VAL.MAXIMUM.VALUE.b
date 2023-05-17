SUBROUTINE REDO.V.VAL.MAXIMUM.VALUE

*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* --------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for :
* Development by  :
* Date            :
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS

*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN

*
* ======
PROCESS:
* ======
*

    Y.COLLATERAL.TYPE.ID = R.NEW(COLL.COLLATERAL.TYPE)
    CALL F.READ(FN.PARMS,Y.COLLATERAL.TYPE.ID,R.PARMS,F.PARMS,Y.PARMS.ERR.MSG)

    Y.MAX.PERC.LOAN =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC>

*   IF Y.MAX.PERC.LOAN GT 0 THEN
*   R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> =  Y.MAX.PERC.LOAN

    R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = Y.NOMINAL.VALUE * Y.MAX.PERC.LOAN / 100

*     R.NEW(COLL.MAXIMUM.VALUE) = R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE>
*   END
*    ELSE
*        AF = Y.COLLATERAL.ID
*        ETEXT = 'ST-REDO.CCRG.MAX.POR.DEF'
*        CALL STORE.END.ERROR
*    END

RETURN


*=========
INITIALISE:
*=========

    FN.PARMS  = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.PARMS   = ''
    R.PARMS   = ''
    Y.PARMS.ERR.MSG = ''

    PROCESS.GOAHEAD = 1
*Set the local fild for read

    WCAMPO    = "L.COL.LN.MX.PER"
    WCAMPO<2> = "L.COL.LN.MX.VAL"

    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.MAX.PERC    = YPOS<1,1>
    WPOS.MAX.VALUE   = YPOS<1,2>

*Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE) ; *** VALOR NOMINAL
    Y.NOMINAL.VALUE = COMI      ;*** VALOR NOMINAL
    Y.COLLATERAL.ID = R.NEW(COLL.COLLATERAL.CODE)

    PROCESS.GOAHEAD = 1

RETURN

*
* ========
OPEN.FILES:
*=========
*

    CALL OPF(FN.PARMS,F.PARMS)
RETURN

* ========


END
