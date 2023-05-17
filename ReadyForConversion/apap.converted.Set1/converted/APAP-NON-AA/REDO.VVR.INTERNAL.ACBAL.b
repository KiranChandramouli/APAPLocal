SUBROUTINE REDO.VVR.INTERNAL.ACBAL
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
    $INSERT I_F.TELLER
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
    IF WERROR.BAL THEN
        ETEXT           = WERROR.BAL
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
* ===============
GET.TRAN.AMOUNT1:
* ===============
*
    IF R.NEW(TT.TE.CURRENCY.1) EQ LCCY THEN
        WTRAN.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END ELSE
        WTRAN.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)
    END
*
RETURN
*
* ===============
GET.TRAN.AMOUNT2:
* ===============
*
    IF R.NEW(TT.TE.CURRENCY.2) EQ LCCY THEN
        WTRAN.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.2)
    END ELSE
        WTRAN.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.2)
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD   = 1
*
    Y.ERR.MSG = ""
*
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
    LOOP.CNT  = 1   ;   MAX.LOOPS = 4
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" AND V$FUNCTION NE "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.1)
                    GOSUB GET.TRAN.AMOUNT1
                    CALL REDO.ANALISE.INTERNA.ACCBAL(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL)
                END

            CASE LOOP.CNT EQ 2
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" AND V$FUNCTION NE "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.2)
                    GOSUB GET.TRAN.AMOUNT2
                    CALL REDO.ANALISE.INTERNA.ACCBAL(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL)
                END

            CASE LOOP.CNT EQ 3
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" AND V$FUNCTION EQ "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.1)
                    GOSUB GET.TRAN.AMOUNT1
                    CALL REDO.ANALISE.INTERNA.ACCBAL(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL)
                END

            CASE LOOP.CNT EQ 4
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" AND V$FUNCTION EQ "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.2)
                    GOSUB GET.TRAN.AMOUNT2
                    CALL REDO.ANALISE.INTERNA.ACCBAL(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL)
                END

        END CASE

*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
