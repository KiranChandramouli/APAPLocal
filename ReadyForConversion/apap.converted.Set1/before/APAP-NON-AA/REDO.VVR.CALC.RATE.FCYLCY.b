*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VVR.CALC.RATE.FCYLCY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.VVR.CALC.RATE.FCYLCY
* PACS        : PACS00172912
*----------------------------------------------------------------------
*
*    Validation routine attached to TT-FX versions
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE         WHO             REFERENCE          DESCRIPTION
*
*  18.04.2012   NAVA V.         TT-FX              Based on REDO.VVR.CALC.AMOUNTS
*
*----------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
*
$INSERT I_TT.COMMON
$INSERT I_TT.EQUATE
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
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
  R.NEW(TT.TE.DEAL.RATE)                 = Y.DEAL
*
  R.NEW(TT.TE.CHARGE.CUSTOMER)  = ""
  R.NEW(TT.TE.CHARGE.ACCOUNT)   = ""
  R.NEW(TT.TE.CHARGE.CATEGORY)  = ""
  R.NEW(TT.TE.CHRG.DR.TXN.CDE)  = ""
  R.NEW(TT.TE.CHRG.CR.TXN.CDE)  = ""
  R.NEW(TT.TE.CHRG.AMT.LOCAL)   = ""
  R.NEW(TT.TE.CHRG.AMT.FCCY)    = ""
  R.NEW(TT.TE.CHARGE.CODE)      = ""
  R.NEW(TT.TE.NET.AMOUNT)       = ""
  R.NEW(TT.TE.DEALER.DESK)      = "00"
*
  CALL TT.PERFORM.DEF.PROCESSING
  CALL TT.GENERAL.LIBRARY(CALL.CALCULATE.NET.AMOUNT)
*
  R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> * Y.DEAL
*
  CALL REDO.HANDLE.COMM.TAX.FIELDS
*
  RETURN
*
*----------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------
*
  PROCESS.GOAHEAD = "1"
  LOOP.CNT        = 1
  MAX.LOOPS       = 1
*
  R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''
*
  IF COMI NE "" THEN
    Y.DEAL       = COMI
  END
*
  RETURN
*
*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
*
      IF MESSAGE EQ "VAL" THEN
        PROCESS.GOAHEAD = ""
      END
*
    END CASE
    LOOP.CNT +=1
*
  REPEAT
*
  RETURN
*
END
