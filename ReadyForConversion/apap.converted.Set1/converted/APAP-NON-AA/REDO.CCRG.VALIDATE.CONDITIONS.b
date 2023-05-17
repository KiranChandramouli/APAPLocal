SUBROUTINE REDO.CCRG.VALIDATE.CONDITIONS(R.IN.CONDITIONS,R.IN.VALUES)
*-----------------------------------------------------------------------------
*
* Routine to validate the operants and values in a condicion parametered of REDO.CCRG.RISK.LIMIT.PARAM
* This routine is invokated by REDO.CCRG.RISK.LIMIT.PARAM.VALIDATE
*
* Parameters:
*
* R.IN.CONDITIONS: Input parameter with the value of the fields to validad in this routine
* R.IN.VALUES:     Input parameter with data required to validate
*                  <1> : position application in validating
*                  <2> : total applications parametrized
*                  <3> : number of conditions in the application in validating
*                  <4> : fields parametrized by applications
*
* @author:     anoriega@temenos.com
* @stereotype: routine
* @package:    REDO.CCRG
*
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 31/March/2011 - BG_100011433
*                 Creation Routine
* 13/April/2011 - vpanchi
*                 Modify for various applications
*-----------------------------------------------------------------------------
*** </region>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*     Process to validate every element of the condicion to
*     filter data in REDO.CCRG.RISK.LIMIT.PARAM
*

    P.IN.OPERATOR  = R.IN.CONDITIONS<REDO.CCRG.RLP.OPERATOR>
    P.IN.MIN.VAL   = R.IN.CONDITIONS<REDO.CCRG.RLP.MIN.VALUE>
    P.IN.MAX.VAL   = R.IN.CONDITIONS<REDO.CCRG.RLP.MAX.VALUE>
    P.IN.BOOL.OPER = R.IN.CONDITIONS<REDO.CCRG.RLP.BOOL.OPER>

    Y.A         = R.IN.VALUES<1>
    Y.CNT.APP   = R.IN.VALUES<2>
    Y.F         = R.IN.VALUES<3>
    Y.CNT.CND   = R.IN.VALUES<4>

    BEGIN CASE
        CASE P.IN.OPERATOR EQ ""
* Validate operator
            AF    = REDO.CCRG.RLP.OPERATOR
            ETEXT = 'ST-REDO.CCRG.OPERATOR.MISSING'
            CALL STORE.END.ERROR
        CASE P.IN.OPERATOR MATCHES 'EQ':@VM:'NE' AND NOT(P.IN.MIN.VAL)
* Validate de operator and min value
            AF    = REDO.CCRG.RLP.MIN.VALUE
            ETEXT = 'ST-REDO.CCRG.P.IN.MIN.VAL.MISSING'
            CALL STORE.END.ERROR
        CASE P.IN.OPERATOR MATCHES 'EQ':@VM:'NE' AND P.IN.MAX.VAL
* Validate de operator and max value
            AF    = REDO.CCRG.RLP.MAX.VALUE
            ETEXT = 'ST-REDO.CCRG.MAX.VALUE.NO.REQUIRED'
            CALL STORE.END.ERROR
        CASE P.IN.OPERATOR MATCHES 'RG':@VM:'NR' AND NOT(P.IN.MIN.VAL)
* Validate de range operator and min value
            AF    = REDO.CCRG.RLP.MIN.VALUE
            ETEXT = 'ST-REDO.CCRG.P.IN.MIN.VAL.MISSING'
            CALL STORE.END.ERROR
        CASE P.IN.OPERATOR MATCHES 'RG':@VM:'NR' AND NOT(P.IN.MAX.VAL)
* Validate de range operator and max value
            AF    = REDO.CCRG.RLP.MAX.VALUE
            ETEXT = 'ST-REDO.CCRG.P.IN.MAX.VAL.MISSING'
            CALL STORE.END.ERROR
        CASE Y.CNT.APP GT Y.A AND NOT(P.IN.BOOL.OPER)
* Validate the bool operator
            AF    = REDO.CCRG.RLP.BOOL.OPER
            ETEXT = 'ST-REDO.CCRG.BOOL.OPER.MISSING'
            CALL STORE.END.ERROR
        CASE Y.CNT.APP EQ Y.A AND Y.CNT.CND GT Y.F AND NOT(P.IN.BOOL.OPER)
* Validate the bool operator and conditions
            AF    = REDO.CCRG.RLP.BOOL.OPER
            ETEXT = 'ST-REDO.CCRG.BOOL.OPER.MISSING'
            CALL STORE.END.ERROR
        CASE Y.CNT.APP EQ Y.A AND Y.CNT.CND EQ Y.F AND P.IN.BOOL.OPER
* Validate the bool operator and conditions
            AF    = REDO.CCRG.RLP.BOOL.OPER
            ETEXT = 'ST-REDO.CCRG.BOOL.OPER.NO.REQUIRED'
            CALL STORE.END.ERROR
    END CASE
*
RETURN
*
END
