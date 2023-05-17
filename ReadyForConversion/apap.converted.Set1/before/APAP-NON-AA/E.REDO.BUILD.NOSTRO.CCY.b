*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.REDO.BUILD.NOSTRO.CCY(ENQ.DATA)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.ENQ.NOSTRO.AC
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Nava V
* Date            : 2012-01-13
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
*
*************************************************************************
*
*
*
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
* ======
PROCESS:
* ======
*
*

  BEGIN CASE
  CASE APPLICATION EQ "TELLER"
    Y.CCY = R.NEW(TT.TE.CURRENCY.2)
    IF Y.CCY EQ "" THEN
      Y.CCY = R.NEW(TT.TE.CURRENCY.1)
    END
  CASE APPLICATION EQ "FUNDS.TRANSFER"
    Y.CCY = R.NEW(FT.DEBIT.CURRENCY)
    IF Y.CCY EQ "" THEN
      Y.CCY = R.NEW(FT.CREDIT.CURRENCY)
    END
  END CASE

  ENQ.DATA<2,1>    = "CURRENCY"
  ENQ.DATA<3,1>    = "EQ"
  ENQ.DATA<4,1,1>    = Y.CCY
*
  RETURN
*
*
*===================
CONTROL.MSG.ERROR:
*===================
*
*   Paragraph that control the error in the subroutine
*
  IF Y.ERR.MSG THEN
    ETEXT           = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT           = ""
  END
*
  RETURN
*
* =========
INITIALISE:
* =========
*
*
  PROCESS.GOAHEAD = 1
  Y.CCY         = ""
*
  Y.ERR.MSG                 = ""
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP.CNT  = 1;    MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1

* -----
    CASE LOOP.CNT EQ 2


    END CASE

    LOOP.CNT +=1
  REPEAT

*
  RETURN
*

END
