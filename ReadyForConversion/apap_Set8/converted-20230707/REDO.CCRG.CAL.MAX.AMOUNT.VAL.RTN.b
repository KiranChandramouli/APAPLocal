SUBROUTINE REDO.CCRG.CAL.MAX.AMOUNT.VAL.RTN
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Validate Routine VERSION REDO.CCRG.RISK.LIMIT.PARAM,MAN FIELD percentage
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine validate the percentage value and calculate the maximo ammount
*  by the Risk Limit IN process
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES
*-----------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:

    IF ID.NEW EQ 'HOUSING.PLAN.APAP' THEN
        TEC.RES.ID = 'SYSTEM'
        R.TECH.RES = ''
        YERR       = ''
        CALL CACHE.READ('F.REDO.CCRG.TECHNICAL.RESERVES',TEC.RES.ID,R.TECH.RES,YERR)

        IF R.TECH.RES THEN
            Y.AMOUNT.TEC.RES =R.TECH.RES<REDO.CCRG.TR.TECH.RES.AMOUNT>
            Y.PORCEN.CAL = COMI * 100 /Y.AMOUNT.TEC.RES
            R.NEW(REDO.CCRG.RLP.PERCENTAGE) = Y.PORCEN.CAL
        END

    END ELSE
        CALL REDO.CCRG.CAL.MAX.AMOUNT ('VAL.RTN')
    END

RETURN

END
