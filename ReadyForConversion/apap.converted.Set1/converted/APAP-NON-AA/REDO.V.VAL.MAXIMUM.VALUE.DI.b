SUBROUTINE REDO.V.VAL.MAXIMUM.VALUE.DI

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
* ---------
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
    CALL F.READ(FN.PARMS, Y.COLLATERAL.TYPE.ID, R.PARMS,F.PARMS,Y.PARMS.ERR.MSG)

*Tus Start
*Y.MAX.PERC.LOAN =  R.PARMS<2>
    Y.MAX.PERC.LOAN =  R.PARMS<FC.PR.PER.MAX.PRESTAR>
*Tus End
    IF Y.MAX.PERC.LOAN GT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> =  Y.MAX.PERC.LOAN
* PACS00307769 - S
*        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = Y.AVA.INST.AMT * Y.MAX.PERC.LOAN / 100
        Y.MAX.CALC.VAL = Y.AVA.INST.AMT * Y.MAX.PERC.LOAN / 100
        Y.MAX.CALC.VAL = DROUND(Y.MAX.CALC.VAL,2)
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = Y.MAX.CALC.VAL
*     R.NEW(COLL.MAXIMUM.VALUE) = R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE>
* PACS00307769 - E
    END
    ELSE
        AF = Y.COLLATERAL.ID
        ETEXT = 'ST-REDO.CCRG.MAX.POR.DEF'
        CALL STORE.END.ERROR
    END

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
    WCAMPO<3> = "L.AVA.AMO.INS"

    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.MAX.PERC    = YPOS<1,1>
    WPOS.MAX.VALUE   = YPOS<1,2>
    WPOS.AVA.INST.AMT = YPOS<1,3>


    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE)
    END ELSE
        Y.NOMINAL.VALUE = COMI
    END

    Y.COLLATERAL.ID = R.NEW(COLL.COLLATERAL.CODE)
    Y.AVA.INST.AMT = R.NEW(COLL.LOCAL.REF)<1,WPOS.AVA.INST.AMT>

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
