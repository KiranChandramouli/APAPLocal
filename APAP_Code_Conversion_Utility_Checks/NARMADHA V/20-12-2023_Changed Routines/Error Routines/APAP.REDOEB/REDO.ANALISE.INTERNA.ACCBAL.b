* @ValidationCode : MjotMjA0MDg3MTU4OTpVVEYtODoxNzAyODc3MTI4Mjk1OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2023 10:55:28
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.ANALISE.INTERNA.ACCBAL(WINTERN.ACCT,WTRAN.AMOUNT,WERROR.BAL)
******************************************************************************
* =============================================================================
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2012/JUL/19
*
* 12-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 18-12-2023      Narmadha V        Manual R22 Conversion   CALL OPF added
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
*
* Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus end
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
* Tus Start
    WACTUAL.BALANCE = R.ECB<ECB.WORKING.BALANCE> * -1
*   Tus End
    WNEW.BALANCE    = WACTUAL.BALANCE - WTRAN.AMOUNT
*
    IF WNEW.BALANCE LT 0 THEN
        TEXT    = "TT-BAL.NOT.ALLOW.FOR.INTAC.&" : @FM : WINTERN.ACCT
        CURR.NO = DCOUNT(R.NEW(V-9),@VM)+1
        CALL STORE.OVERRIDE(CURR.NO)
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
    Y.ERR.MSG = ""
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT) ;*Manual R22 Conversion - CALL OPF added
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
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(WINTERN.ACCT) OR NOT(WTRAN.AMOUNT) THEN
                    WERROR.BAL      = "EB-INP.MISSI"
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.ACCOUNT,WINTERN.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
*Tus start
                R.ECB = ''
                ECB.ERR = ''
                CALL EB.READ.HVT('EB.CONTRACT.BALANCES',WINTERN.ACCT,R.ECB,ECB.ERR)
* Tus end
                IF ERR.ACCT THEN
                    WERROR.BAL      = "AC-ACCOUNT.NOT.FOUND"
                    PROCESS.GOAHEAD = ""
                END
*
        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
