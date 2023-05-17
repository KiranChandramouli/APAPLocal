SUBROUTINE REDO.CCRG.ALLOWED.APP(P.IN.RTN, P.IN.APPLICATION)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------
*  This routine validate the application to add will be only CUSTOMER or
*  AA.PRD.DES.CUSTOMER
*
*  Input Param:
*  ------------
*  P.IN.RTN: This param indicate wich is the routine that invocate
*            this is because, depending of the event and the routine the
*            common variables has or not value (COMI, R.NEW)
*            Values:
*            VAL.RTN:  Validate Routine related to the APPICATION field
*            VALIDATE: Template VALIDATE of the application REDO.CCRG.RISK.LIMIT.PARAM
*
*  P.IN.APPLICATION: Application Name to validate
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
*-----------------------------------------------------------------------------

    GOSUB CHECK.PRELIM.CONDITIONS
RETURN

*-----------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

    AF    = REDO.CCRG.RLP.APPLICATION
* If the ID is RISK.INDIV.SECURED or RISK.INDIV.UNSECURED or RISK.GROUP.TOTAL or RISK.INDIV.TOTAL,
* is not required to input this conditions fields
*   IF  ID.NEW MATCHES 'RISK.INDIV.SECURED':VM:'RISK.INDIV.UNSECURED':VM:'RISK.GROUP.TOTAL':VM:'RISK.INDIV.TOTAL'  THEN
    IF ID.NEW MATCHES 'RISK.GROUP.TOTAL' THEN
        IF P.IN.APPLICATION THEN
            ETEXT = 'ST-REDO.CCRG.CONDTS.NOT.APPLY.TO.RL'
            CALL STORE.END.ERROR
        END
        RETURN
    END

* Validate the Application Name inputted be CUSTOMER
    IF P.IN.APPLICATION NE 'CUSTOMER' THEN
        ETEXT = 'ST-REDO.CCRG.APPLICATION.NAME.INVALID' : @FM : P.IN.APPLICATION
        CALL STORE.END.ERROR
    END
RETURN

END
