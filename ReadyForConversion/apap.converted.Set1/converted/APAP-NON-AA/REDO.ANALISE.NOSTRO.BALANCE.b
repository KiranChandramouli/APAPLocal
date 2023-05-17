SUBROUTINE REDO.ANALISE.NOSTRO.BALANCE(WNOSTRO.ACCT,WTRAN.AMOUNT,WERROR.BAL)
******************************************************************************
* =============================================================================
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2012/JUL/19
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------
PROCESS:
*--------
*
    WACTUAL.BALANCE = R.ACCOUNT<AC.LOCAL.REF,WPOS.BAL> * -1
    WNEW.BALANCE    = WACTUAL.BALANCE - WTRAN.AMOUNT
    IF WNEW.BALANCE LT 0 THEN
        TEXT    = "TT-NEGATIVE.BALANCE.FOR.NOSTRO.&" : @FM : WNOSTRO.ACCT
        CURR.NO = DCOUNT(R.NEW(V-9),@VM)+1
        CALL STORE.OVERRIDE(CURR.NO)
    END
*
RETURN
*
* ======================
CHECK.IF.NOSTRO.ACCOUNT:
* ======================
*
    W.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    ID.AC.CLS.CATEGORY = "NOSTRO"

    CALL CACHE.READ(FN.ACCOUNT.CLASS, ID.AC.CLS.CATEGORY, R.ACCOUNT.CLASS, CLASS.YERR)
    WCLASS.CATEGORY = RAISE(R.ACCOUNT.CLASS<AC.CLS.CATEGORY>)
*
    LOCATE W.CATEGORY IN WCLASS.CATEGORY<1> SETTING CAT.POS ELSE
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD   = 1
    WERROR.BAL        = ""
*
    WCAMPO    = "L.AC.AV.BAL"

    CALL MULTI.GET.LOC.REF("ACCOUNT",WCAMPO,YPOS)
    WPOS.BAL = YPOS<1,1>
*
    Y.ERR.MSG = ""
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
*
    FN.ACCOUNT.CLASS = "F.ACCOUNT.CLASS"
    F.ACCOUNT.CLASS  = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(WNOSTRO.ACCT) OR NOT(WTRAN.AMOUNT) THEN
                    WERROR.BAL      = "EB-MISSING.PARAMETERS.NOSTRO.BALANCE"
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.ACCOUNT,WNOSTRO.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
                IF ERR.ACCT THEN
                    WERROR.BAL      = "AC-ACCOUNT.NOT.FOUND"
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                GOSUB CHECK.IF.NOSTRO.ACCOUNT


        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
