*-------------------------------------------------------------------------
* <Rating>-40</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE  REDO.V.VAL.CUSTACC
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as VALIDATION routine in ACCOUNT.1 or ACCOUNT.2 field
* for versions related to THIRDPARTY Cash (DEBIT/CREDIT) and Check operations:
*TELLER,REDO.LCY.CASHIN.ME
*TELLER,REDO.LCY.CASHIN.ML
*TELLER,REDO.EFC.PAG.OTROS
*TELLER,REDO.EFC.PAG.OTROS.ME
*TELLER,REDO.OTHER.INCOMES.CASH.ML
*TELLER,REDO.OTHER.INCOMES.CASH.ME
*TELLER,REDO.OTHER.INCOMES.CHQOBCO.ML
*TELLER,REDO.OTHER.INCOMES.CHQOBCO.ME
*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date            who             Reference            Description
*   ~~~~            ~~~             ~~~~~~~~~            ~~~~~~~~~~~
*   02-MAR-2013     NAVA V.         PACS00260032         Initial Creation
*-------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT
*
  GOSUB INIT
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  CALL REDO.V.INP.TT.AC.VAL
*
  RETURN
*---------------------------------------------------------------------------
*
* ======
PROCESS:
* ======
*
  R.ACCOUNT = '' ; YERR = ''
  CALL F.READ(FN.ACCOUNT,W.ACCT,R.ACCOUNT,F.ACCOUNT,YERR)
  IF R.ACCOUNT NE "" THEN
    WCUST = R.ACCOUNT<AC.CUSTOMER>
    GOSUB VAL.CUSACC
  END
*
  RETURN
*
*----------------------------------------------------------------------------
*
* =========
VAL.CUSACC:
* =========
*
  IF WCUST NE "" THEN
    ETEXT = "TT-INT.ACCT"
    CALL STORE.END.ERROR
  END
*
  RETURN
*
* ===
INIT:
* ===
*
  PROCESS.GOAHEAD      = 1
  W.ACCT               = COMI
  WCUST                = ''
*
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP.CNT  = 1
  MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1

      IF MESSAGE EQ "VAL" THEN
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2

    END CASE
    LOOP.CNT +=1
*
  REPEAT
*
  RETURN
*
END
