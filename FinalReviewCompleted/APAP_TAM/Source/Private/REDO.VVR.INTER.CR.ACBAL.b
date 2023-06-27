* @ValidationCode : MjoxNDQxNDg2Njg4OkNwMTI1MjoxNjg0ODQyMTUzNjIwOklUU1M6LTE6LTE6LTcxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -71
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VVR.INTER.CR.ACBAL
******************************************************************************
* =============================================================================
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2012/JUL/19
*
** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes, CALL routine format modified
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
*
    $USING APAP.REDOEB
    
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
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.2)
                    GOSUB GET.TRAN.AMOUNT1
                    APAP.REDOEB.redoAnaliseInterCrAccbal(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL) ;*MANUAL R22 CODE CONVERSION
                END

            CASE LOOP.CNT EQ 2
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" AND V$FUNCTION NE "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.1)
                    GOSUB GET.TRAN.AMOUNT2
                    APAP.REDOEB.redoAnaliseInterCrAccbal(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL) ;*MANUAL R22 CODE CONVERSION
                END

            CASE LOOP.CNT EQ 3
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" AND V$FUNCTION EQ "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.2)
                    GOSUB GET.TRAN.AMOUNT1
                    APAP.REDOEB.redoAnaliseInterCrAccbal(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL) ;*MANUAL R22 CODE CONVERSION
                END

            CASE LOOP.CNT EQ 4
                IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" AND V$FUNCTION EQ "R" THEN
                    WINTERAC.ACCT = R.NEW(TT.TE.ACCOUNT.1)
                    GOSUB GET.TRAN.AMOUNT2
                    APAP.REDOEB.redoAnaliseInterCrAccbal(WINTERAC.ACCT,WTRAN.AMOUNT,WERROR.BAL) ;*MANUAL R22 CODE CONVERSION
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
