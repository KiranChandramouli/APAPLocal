*-----------------------------------------------------------------------------------------------------
* <Rating>-90</Rating>
*-----------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.V.MM.PRECLOSE.INT.ACCR
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is auth routine attached to the below versions
*               MM.MONEY.MARKET,REDO.PLACE
*               MM.MONEY.MARKET,REDO.PLACE.CALL
*               MM.MONEY.MARKET,REDO.TAKING
*               MM.MONEY.MARKET,REDO.TKGCALL
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arundev KR
* PROGRAM NAME : REDO.V.MM.PRECLOSE.INT.ACCR
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference          Description
* 18-Feb-2013      Arundev KR         RTC-553577         CR008 Discount Amortisation
*------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_F.REDO.APAP.L.CONTRACT.BALANCES
$INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
$INSERT I_F.STMT.ENTRY
$INSERT I_F.CATEG.ENTRY

  GOSUB INITIALISE
  GOSUB OPENFILES
  GOSUB GETLOCREF
  GOSUB PROCESS

  RETURN

*-------------------------------------------------------------------------
INITIALISE:
*-------------------------------------------------------------------------

  APAP.LCCY = LCCY

  RETURN

*-------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------

  FN.REDO.APAP.L.CONTRACT.BALANCES = 'F.REDO.APAP.L.CONTRACT.BALANCES'
  F.REDO.APAP.L.CONTRACT.BALANCES = ''
  CALL OPF(FN.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES)

  FN.REDO.APAP.H.PRODUCT.DEFINE = 'F.REDO.APAP.H.PRODUCT.DEFINE'
  F.REDO.APAP.H.PRODUCT.DEFINE = ''
  CALL OPF(FN.REDO.APAP.H.PRODUCT.DEFINE,F.REDO.APAP.H.PRODUCT.DEFINE)

  RETURN

*-------------------------------------------------------------------------
GETLOCREF:
*-------------------------------------------------------------------------

  RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------

  MM.ID = ID.NEW
  CUSTOMER.NO = R.NEW(MM.CUSTOMER.ID)
  MM.CCY = R.NEW(MM.CURRENCY)
  MM.CCY.MARKET = R.NEW(MM.CURRENCY.MARKET)


  MM.CAT.FLAG = ''
  MM.CAT = R.NEW(MM.CATEGORY)
  IF (MM.CAT GE 21076) AND (MM.CAT LE 21084) THEN
    MM.CAT.FLAG = 1
  END

  GOSUB READ.REDO.APAP.L.CONTRACT.BALANCES
  GOSUB READ.REDO.APAP.H.PRODUCT.DEFINE

  LIN.AMT = R.NEW(MM.TOT.INTEREST.AMT)
  EIA = R.APAP.CONTRACT.BAL<CRT.BAL.ACCRUE.TO.DATE>
  DIFF.AMT = DROUND((LIN.AMT - EIA),2)

  IF MM.CCY NE LCCY THEN
    DIFF.FCY.AMT = DIFF.AMT
    DIFF.LCY.AMT = ''
    EXCH.RATE = ''
    CALL EXCHRATE(MM.CCY.MARKET,MM.CCY,DIFF.FCY.AMT,APAP.LCCY,DIFF.LCY.AMT,'',EXCH.RATE,'','','')
  END ELSE
    DIFF.LCY.AMT = DIFF.AMT
    DIFF.FCY.AMT = ''
  END

  ACC.ENTRY.ARRAY = ''
  IF DIFF.AMT AND MM.CAT.FLAG THEN
    GOSUB FORM.STMT.ENTRY
    ACC.ENTRY.ARRAY<-1> = LOWER(STMT.ENTRY.ARRAY)
    GOSUB FORM.CATEG.ENTRY
    ACC.ENTRY.ARRAY<-1> = LOWER(CATEG.ENTRY.ARRAY)
  END

  IF ACC.ENTRY.ARRAY THEN
    CALL EB.ACCOUNTING("MM","SAO",ACC.ENTRY.ARRAY,'')
  END

  RETURN

*-------------------------------------------------------------------------
READ.REDO.APAP.L.CONTRACT.BALANCES:
*-------------------------------------------------------------------------

  R.APAP.CONTRACT.BAL = ''
  APAP.CONTRACT.BAL.ERR = ''
  APAP.CONTRACT.BAL.ID = ID.NEW
  CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,APAP.CONTRACT.BAL.ID,R.APAP.CONTRACT.BAL,F.REDO.APAP.L.CONTRACT.BALANCES,APAP.CONTRACT.BAL.ERR)

  RETURN

*-------------------------------------------------------------------------
READ.REDO.APAP.H.PRODUCT.DEFINE:
*-------------------------------------------------------------------------

  R.APAP.PRODUCT = ''
  APAP.PRODUCT.ERR = ''
  APAP.PRODUCT.ID = 'SYSTEM'

*  CALL F.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,APAP.PRODUCT.ID,R.APAP.PRODUCT,F.REDO.APAP.H.PRODUCT.DEFINE,APAP.PRODUCT.ERR) ;*Tus Start 
CALL CACHE.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,APAP.PRODUCT.ID,R.APAP.PRODUCT,APAP.PRODUCT.ERR) ; * Tus End

  APAP.LOAN.CATEG = ''
  APAP.LOAN.CATEG = R.APAP.PRODUCT<PRD.DEF.LOAN.CATEG>
  APAP.LOAN.ACC = MM.CCY:APAP.LOAN.CATEG:'0001'

  MM.CR.TXN.CODE = R.APAP.PRODUCT<PRD.DEF.INT.PAY.TXN.CODE>
  MM.DR.TXN.CODE = R.APAP.PRODUCT<PRD.DEF.INT.ACC.TXN.CODE>
  MM.PL.CATEG = R.APAP.PRODUCT<PRD.DEF.INT.ACC.PL.CATEG>

  RETURN

*-------------------------------------------------------------------------
FORM.STMT.ENTRY:
*-------------------------------------------------------------------------

  STMT.ENTRY.ARRAY = ''
  STMT.ENTRY.ARRAY<AC.STE.ACCOUNT.NUMBER>   = APAP.LOAN.ACC
  STMT.ENTRY.ARRAY<AC.STE.COMPANY.CODE>     = ID.COMPANY
  STMT.ENTRY.ARRAY<AC.STE.AMOUNT.LCY>       = DIFF.AMT

  IF STMT.ENTRY.ARRAY<AC.STE.AMOUNT.LCY> GT 0 THEN
    STMT.ENTRY.ARRAY<AC.STE.TRANSACTION.CODE> = MM.CR.TXN.CODE
  END ELSE
    STMT.ENTRY.ARRAY<AC.STE.TRANSACTION.CODE> = MM.DR.TXN.CODE
  END

  STMT.ENTRY.ARRAY<AC.STE.NARRATIVE,1> = 'MM Pre Close'
  STMT.ENTRY.ARRAY<AC.STE.CUSTOMER.ID>      = CUSTOMER.NO
  STMT.ENTRY.ARRAY<AC.STE.VALUE.DATE>       = TODAY
  STMT.ENTRY.ARRAY<AC.STE.CURRENCY>         = MM.CCY

  IF DIFF.FCY.AMT THEN
    STMT.ENTRY.ARRAY<AC.STE.AMOUNT.FCY>       = DIFF.FCY.AMT
    STMT.ENTRY.ARRAY<AC.STE.EXCHANGE.RATE >   = EXCH.RATE
  END

  STMT.ENTRY.ARRAY<AC.STE.POSITION.TYPE>    = 'TR'
  STMT.ENTRY.ARRAY<AC.STE.OUR.REFERENCE>    = MM.ID
  STMT.ENTRY.ARRAY<AC.STE.EXPOSURE.DATE>    = TODAY
  STMT.ENTRY.ARRAY<AC.STE.CURRENCY.MARKET>  = MM.CCY.MARKET
  STMT.ENTRY.ARRAY<AC.STE.TRANS.REFERENCE>  = MM.ID
  STMT.ENTRY.ARRAY<AC.STE.SYSTEM.ID>        = 'MM'
  STMT.ENTRY.ARRAY<AC.STE.BOOKING.DATE>     = TODAY

  RETURN

*-------------------------------------------------------------------------
FORM.CATEG.ENTRY:
*-------------------------------------------------------------------------

  CATEG.ENTRY.ARRAY = ''
  CATEG.ENTRY.ARRAY<AC.CAT.COMPANY.CODE>     = ID.COMPANY
  CATEG.ENTRY.ARRAY<AC.CAT.AMOUNT.LCY>       = (-1) * DIFF.LCY.AMT

  IF CATEG.ENTRY.ARRAY<AC.CAT.AMOUNT.LCY> GT 0 THEN
    CATEG.ENTRY.ARRAY<AC.CAT.TRANSACTION.CODE> = MM.CR.TXN.CODE
  END ELSE
    CATEG.ENTRY.ARRAY<AC.CAT.TRANSACTION.CODE> = MM.DR.TXN.CODE
  END

  CATEG.ENTRY.ARRAY<AC.CAT.NARRATIVE,1>      = 'MM Pre Close'
  CATEG.ENTRY.ARRAY<AC.CAT.PL.CATEGORY>      = MM.PL.CATEG
  CATEG.ENTRY.ARRAY<AC.CAT.CUSTOMER.ID>      = CUSTOMER.NO
  CATEG.ENTRY.ARRAY<AC.CAT.VALUE.DATE>       = TODAY
  CATEG.ENTRY.ARRAY<AC.CAT.CURRENCY>         = MM.CCY

  IF DIFF.FCY.AMT THEN
    CATEG.ENTRY.ARRAY<AC.CAT.AMOUNT.FCY>       = (-1) * DIFF.FCY.AMT
    CATEG.ENTRY.ARRAY<AC.CAT.EXCHANGE.RATE>    = EXCH.RATE
  END

  CATEG.ENTRY.ARRAY<AC.CAT.OUR.REFERENCE>    = MM.ID
  CATEG.ENTRY.ARRAY<AC.CAT.EXPOSURE.DATE>    = TODAY
  CATEG.ENTRY.ARRAY<AC.CAT.CURRENCY.MARKET>  = MM.CCY.MARKET
  CATEG.ENTRY.ARRAY<AC.CAT.TRANS.REFERENCE>  = MM.ID
  CATEG.ENTRY.ARRAY<AC.CAT.SYSTEM.ID>        = "MM"
  CATEG.ENTRY.ARRAY<AC.CAT.BOOKING.DATE>     = TODAY

  RETURN

*-------------------------------------------------------------------------
END
