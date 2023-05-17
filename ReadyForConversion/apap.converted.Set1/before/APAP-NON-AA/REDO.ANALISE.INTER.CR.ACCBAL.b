*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ANALISE.INTER.CR.ACCBAL(WINTERN.ACCT,WTRAN.AMOUNT,WERROR.BAL)
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
*
*Tus start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus end
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
 WACTUAL.BALANCE = R.ECB<ECB.WORKING.BALANCE>
 * Tus End
  WNEW.BALANCE    = WACTUAL.BALANCE - WTRAN.AMOUNT
*
  IF WNEW.BALANCE LT 0 THEN
    TEXT    = "TT-BAL.NOT.ALLOW.FOR.INTAC.&" : FM : WINTERN.ACCT
    CURR.NO = DCOUNT(R.NEW(V-9),VM)+1
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
*      Tus start
      R.ECB = ''
      ECB.ERR = ''
      CALL EB.READ.HVT('EB.CONTRACT.BALANCES',WINTERN.ACCT,R.ECB,ECB.ERR)
*      Tus end
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
