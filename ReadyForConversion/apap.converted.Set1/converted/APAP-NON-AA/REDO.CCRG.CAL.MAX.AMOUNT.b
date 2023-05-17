SUBROUTINE REDO.CCRG.CAL.MAX.AMOUNT(P.IN.RTN)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine validate the percentage value and calculate the maximo ammount
*  by the Risk Limit IN process
*
*  Input Param:
*  ------------
*  P.IN.RTN: This param indicate wich is the routine that invocate
*            this is because, depending of the event and the routine the
*            common variables has or not value (COMI, R.NEW)
*            Values:
*            VAL.RTN:  Validate Routine related to the PERCENTAGE field
*            RECORD:   Template RECORD of the application REDO.CCRG.RISK.LIMIT.PARAM
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
RETURN

*-----------------------------------------------------------------------------
PROCESS:

* Get TECHNICAL.RESERVES value
    CALL CACHE.READ('F.REDO.CCRG.TECHNICAL.RESERVES',TEC.RES.ID,R.TEC.RES,YERR)

* Calculate Max Amount by Risk Limit
    Y.AMOUNT      = R.TEC.RES<REDO.CCRG.TR.TECH.RES.AMOUNT>
    Y.MAX.AMOUNT  = Y.AMOUNT * Y.PERCENTAGE / 100

* Populate REDO.CCRG.RLP.MAX.AMOUNT field
    R.NEW(REDO.CCRG.RLP.MAX.AMOUNT) = Y.MAX.AMOUNT

RETURN
*-----------------------------------------------------------------------------
INITIALISE:

    PROCESS.GOAHEAD  = 1
* Id process
    Y.RL.ID          = ID.NEW
* Initialise Values
    TEC.RES.ID       = 'SYSTEM'
    R.TEC.RES        = ''
    YERR             = ''
* Set percentage value
    IF P.IN.RTN EQ 'VAL.RTN' THEN
        Y.PERCENTAGE     = COMI
    END
    IF P.IN.RTN EQ 'RECORD' THEN
        Y.PERCENTAGE     = R.NEW(REDO.CCRG.RLP.PERCENTAGE)
    END

RETURN

*-----------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

* If the ID is RISK.GROUP.TOTAL or RISK.INDIV.TOTAL, the percentage
* is not required to input this value
*   IF  Y.RL.ID MATCHES 'RISK.GROUP.TOTAL':VM:'RISK.INDIV.TOTAL' THEN
*      PROCESS.GOAHEAD = 0

*      AF    = REDO.CCRG.RLP.PERCENTAGE
*      IF Y.PERCENTAGE NE '' AND P.IN.RTN = 'VAL.RTN' THEN
*         ETEXT = 'ST-REDO.CCRG.CONDTS.NOT.APPLY.TO.RL'
*         CALL STORE.END.ERROR
*      END
*      IF Y.PERCENTAGE NE '' AND P.IN.RTN = 'RECORD' THEN
*         E = 'ST-REDO.CCRG.CONDTS.NOT.APPLY.TO.RL'
*      END
*      RETURN
*   END

* Validate the percentage value is between 0 and 100
    IF Y.PERCENTAGE LT 0 OR Y.PERCENTAGE GT 100 THEN
        PROCESS.GOAHEAD = 0
        AF    = REDO.CCRG.RLP.PERCENTAGE
        IF P.IN.RTN EQ 'VAL.RTN' THEN
            ETEXT = 'ST-REDO.CCRG.PERCENTAGE.VALUE.INVALID'
            CALL STORE.END.ERROR
        END
        IF P.IN.RTN EQ 'RECORD' THEN
            E = 'ST-REDO.CCRG.PERCENTAGE.VALUE.INVALID'
        END
    END

RETURN

END
