*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VVR.CALC.AMTS.FCYLCY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.VVR.CALC.AMTS.FCYLCY
* PACS        : PACS00172912
*----------------------------------------------------------------------
*
*    Validation routine attached to TT-FX versions
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE         WHO                 REFERENCE          DESCRIPTION
*
*  16.04.2012   NAVA V.             GROUP7 TT-FX       Based on REDO.VVR.CALC.AMOUNTS
*  21.02.2013   Pradeep S           PACS00250002       Amount rounding
*  02.10.2013   Vignesh Kumaar R    PACS00319443       DEALSLIP PRINT IN CASHIER SCREEN
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
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.FT.COMMISSION.TYPE
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
  R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>   = Y.BASE.AMT
*
  CALL TT.PERFORM.DEF.PROCESSING
  CALL TT.GENERAL.LIBRARY(CALL.CALCULATE.NET.AMOUNT)
*
* PACS00250002 - S

  Y.LCCY.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> * R.NEW(TT.TE.DEAL.RATE)
  CALL EB.ROUND.AMOUNT(LCCY,Y.LCCY.AMT,"2","")    ;* Fix for PACS00319443
*
  R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = Y.LCCY.AMT
*
  R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = Y.LCCY.AMT
*
*PACS00250002 - E

  CALL REDO.HANDLE.COMM.TAX.FIELDS
*
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
  Y.BASE.AMT         = ''
  R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''
*
  R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = ''
*
  LOC.REF.APPLICATION = 'TELLER'
  LOC.REF.FIELDS      = 'L.TT.BASE.AMT'
  LOC.REF.FIELDS<2>   = 'L.DEBIT.AMOUNT'
  LOC.REF.FIELDS<3>   = 'L.CREDIT.AMOUNT'
  CHANGE FM TO VM IN LOC.REF.FIELDS
*
  LREF.POS = ''
*
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
  POS.BASE.AMT     = LREF.POS<1,1>
  DEBIT.POS        = LREF.POS<1,2>
  CREDIT.POS       = LREF.POS<1,3>
*
  IF COMI NE "" THEN
    Y.BASE.AMT       = COMI
  END
*
  RETURN
*
*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
  FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
  F.TELLER.TRANSACTION = ''

  FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE = ''

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT, F.ACCOUNT);
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
