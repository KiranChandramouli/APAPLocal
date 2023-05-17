SUBROUTINE REDO.V.INP.REVALUATION
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is an input routine attached to below version,
*                COLLATERAL,APAP.REVALUATION
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.V.INP.REVALUATION
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 02-Jul-2010      Naveenkumar N    ODR-2009100344               Inital creation
* 21-Jul-2010       Sujitha S
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.RIGHT

    GOSUB INIT
    GOSUB PROCESS
    GOSUB LOAN.UNSECURED
RETURN

*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    R.ACCOUNT = ""
    E.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = ""
    R.AA.ARRANGEMENT = ""
    E.AA.ARRANGEMENT = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.COLLATERAL.RIGHT="F.COLLATERAL.RIGHT"
    F.COLLATERAL.RIGHT=""
    R.COLLATERAL.RIGHT=""
    CALL OPF(FN.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT)

    FN.LIMIT.ARRANGEMENT='F.LIMIT.ARRANGEMENT'
    F.LIMIT.ARRANGEMENT=''
    R.LIMIT.ARRANGEMENT=''
    CALL OPF(FN.LIMIT.ARRANGEMENT,F.LIMIT.ARRANGEMENT)

    OVERRIDE.CNT = ""
RETURN

*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------

    Y.COLL.CURRENCY = R.NEW(COLL.CURRENCY)
    Y.APPLICATION.ID = R.NEW(COLL.APPLICATION.ID)
    Y.COLLATERAL.ID = ID.NEW
    Y.COLLATERAL.RIGHT.ID = FIELD(Y.COLLATERAL.ID,'.',1,2)

    CALL F.READ(FN.COLLATERAL.RIGHT,Y.COLLATERAL.RIGHT.ID,R.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT,COLL.RIGHT.ERR)
    Y.LIMIT.ID=R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>

    CALL F.READ(FN.LIMIT.ARRANGEMENT,Y.LIMIT.ID,R.LIMIT.ARRANGEMENT,F.LIMIT.ARRANGEMENT,LIM.ARR.ERR)
    Y.ARRANGEMENT.ID = R.LIMIT.ARRANGEMENT<1>

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,E.AA.ARRANGEMENT)
    Y.ARRANGEMENT.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>

    IF Y.ARRANGEMENT.CURRENCY AND Y.COLL.CURRENCY NE Y.ARRANGEMENT.CURRENCY THEN
        AF=COLL.CURRENCY
        ETEXT = "EB-CCY.NOT.EQUAL"
        CALL STORE.END.ERROR
    END
RETURN

*----------------------------------------------------------------------------------------
LOAN.UNSECURED:
*----------------------------------------------------------------------------------------

    Y.ARRANGEMENT.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    IF Y.ARRANGEMENT.STATUS EQ "CURRENT" THEN
        TEXT = "LOAN.UNSECURED"
        OVERRIDE.CNT = DCOUNT(R.NEW(COLL.OVERRIDE),@VM)
        OVERRIDE.CNT += 1
        CALL STORE.OVERRIDE(OVERRIDE.CNT)
    END
RETURN

END
