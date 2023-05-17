*-----------------------------------------------------------------------------
* <Rating>-191</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.SC.SOD.REV.STMT.ENTRY(Y.ID)
*-----------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for Spec entries that raised on the bussiness day from RE.SPEC.ENT.TODAY to reverse and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*-----------------------------------------------------------------------------
* * Input / Output
* -----------------------------------------------------------------------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.B.SC.SOD.REV.STMT.ENTRY
*-----------------------------------------------------------------------------
* Modification History :
* Date             Author             Reference           Description
* 06 Jul 2011      Pradeep S          PACS00080124        Initial Creation
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.DATES
$INSERT I_F.STMT.ENTRY
$INSERT I_F.CATEG.ENTRY
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.RE.CONSOL.SPEC.ENTRY
$INSERT I_F.SC.TRADING.POSITION
$INSERT I_F.SC.TRADE.POS.HISTORY
$INSERT I_F.SEC.TRADE
$INSERT I_F.REDO.APAP.L.CONTRACT.BALANCES
$INSERT I_REDO.B.SC.SOD.REV.STMT.ENTRY.COMMON
$INSERT I_F.SEC.ACC.MASTER

  GOSUB PROCESS

  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-------

  R.REDO.APAP.L.SC.ENTRIES = ''
  REDO.APAP.L.SC.ENTRIES.ERR = ''
  CALL F.READ(FN.REDO.APAP.L.SC.ENTRIES,Y.ID,R.REDO.APAP.L.SC.ENTRIES,F.REDO.APAP.L.SC.ENTRIES,REDO.APAP.L.SC.ENTRIES.ERR)
  IF R.REDO.APAP.L.SC.ENTRIES THEN
    RETURN
  END

  R.RE.TODAY = ''
  CALL F.READ(FN.SPEC.TODAY,Y.ID,R.RE.TODAY,F.SPEC.TODAY,TDY.ERR)
  IF R.RE.TODAY THEN
    Y.XREF.ID = R.RE.TODAY:'-1':
    GOSUB MAIN.PROCESS
  END

  RETURN

MAIN.PROCESS:
**************
  R.XREF = ''
  CALL F.READ(FN.SPEC.XREF,Y.XREF.ID,R.XREF,F.SPEC.XREF,XREF.ERR)
  IF R.XREF THEN
    LOOP
      REMOVE Y.DTL.ID FROM R.XREF SETTING POS2
    WHILE Y.DTL.ID:POS2
      GOSUB READ.DTL
    REPEAT
  END ELSE
    GOSUB READ.SPEC
  END

  RETURN
READ.DTL:
**********
  R.DTL = ''
  CALL F.READ(FN.SPEC.DTL,Y.DTL.ID,R.DTL,F.SPEC.DTL,DTL.ERR)
  Y.SPEC.ID = Y.DTL.ID
  IF R.DTL AND R.DTL<RE.CSE.TRANSACTION.CODE> EQ 'ACC' THEN
    R.SPEC.ENTRY = R.DTL
    GOSUB FINAL.PROCESS
  END

  RETURN


READ.SPEC:
************
  Y.SPEC.ID = R.RE.TODAY
  R.SPEC = ''
  CALL F.READ(FN.SPEC,Y.SPEC.ID,R.SPEC,F.SPEC,SPEC.ERR)
  IF R.SPEC AND R.SPEC<RE.CSE.TRANSACTION.CODE> EQ 'ACC' THEN
    R.SPEC.ENTRY = R.SPEC
    GOSUB FINAL.PROCESS
  END

  RETURN


FINAL.PROCESS:
**************

  Y.PROCESS.GOHEAD = @TRUE
  Y.COMMON.ARRAY = ''
  GOSUB CALC.NEW.ACCRUAL
  IF Y.PROCESS.GOHEAD THEN
    GOSUB STMT.ENTRY
    Y.COMMON.ARRAY = LOWER(R.SPEC.ENT)
    GOSUB CATEG.ENTRY
    Y.COMMON.ARRAY<-1> = LOWER(R.SPEC.ENT)
    GOSUB CALL.EB.ACCOUNTING
    GOSUB UPD.L.SC.ENTRIES
  END

  RETURN

CALC.NEW.ACCRUAL:
******************

  Y.SUB.ASSEST.TYPE = ''
  Y.SEC.TRADE.ID = R.SPEC.ENTRY<RE.CSE.OUR.REFERENCE>

  IF INDEX(Y.SEC.TRADE.ID,".",1) ELSE
    Y.PROCESS.GOHEAD = @FALSE
    RETURN
  END

  Y.SPEC.AMT = ABS(R.SPEC.ENTRY<RE.CSE.AMOUNT.LCY>)
  Y.SEC.TRADE.ID = FIELD(Y.SEC.TRADE.ID,"*",1)
  Y.SEC.CODE = FIELD(Y.SEC.TRADE.ID,".",2)

  R.SECURITY.MASTER = ''
  CALL F.READ(FN.SECURITY.MASTER,Y.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)

  IF R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE> EQ 'S'  THEN
    Y.PROCESS.GOHEAD = @FALSE
    RETURN
  END

  IF R.SECURITY.MASTER THEN
    Y.SM.PAR.VALUE = R.SECURITY.MASTER<SC.SCM.PAR.VALUE>
    Y.SEC.CCY = R.SECURITY.MASTER<SC.SCM.SECURITY.CURRENCY>
    GOSUB CALCULATIONS
  END

  RETURN

CALCULATIONS:
**************

  R.SAM = ''
  SAM.ERR = ''
  CALL F.READ(FN.SEC.ACC.MASTER,SAM.ID,R.SAM,F.SEC.ACC.MASTER,SAM.ERR)

  CUSTOMER.NO = R.SAM<SC.SAM.CUSTOMER.NUMBER>

  INT.ADJ.CAT = R.SAM<SC.SAM.LOCAL.REF,POS.L.INT.ADJ.CAT>
  INT.ADJ.ACC = Y.SEC.CCY:INT.ADJ.CAT:'0001'

  INT.PL.CAT = R.SAM<SC.SAM.INT.RECD.CAT>

  R.SC.TRADING.POSITION = ''
  CALL F.READ(FN.SC.TRADING.POSITION,Y.SEC.TRADE.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,E.SC.TRADING.POSITION)
  IF R.SC.TRADING.POSITION THEN
    FACE.VALUE    = R.SC.TRADING.POSITION<SC.TRP.CURRENT.POSITION>
    Y.ACCR.POSTED = R.SC.TRADING.POSITION<SC.TRP.CPN.ACCR.POSTED>

    SC.NOMINAL = R.SC.TRADING.POSITION<SC.TRP.CURRENT.POSITION>
    TRANS.TYPE = R.SC.TRADING.POSITION<SC.TRP.TRD.TRANS.TYPE,1>

    INTEREST.RATE      = R.SECURITY.MASTER<SC.SCM.INTEREST.RATE>
    BASE.1             = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    BASE               = FIELD(BASE.1,'/',2)
    ACCRUAL.START.DATE = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>
    INT.PAYMENT.DATE   = R.SECURITY.MASTER<SC.SCM.INT.PAYMENT.DATE>
    REGION.CODE        = ""

    COUPON.TENOR = "C"
    DAYS = "C"

    GOSUB PRE.CALC

    CALC1          = (INTEREST.RATE/100)/BASE
    CALC2          = (CALC1 * COUPON.TENOR)
    CALC3          = (1 + CALC2)

    CALC.EXP1      = (DAYS/COUPON.TENOR)

    CALC4          = PWR(CALC3,CALC.EXP1)
    EFF.RATE       = (CALC4 - 1)
    EFFECTIVE.RATE = EFF.RATE

    INT.ACCRUAL.VAL  = (FACE.VALUE*EFFECTIVE.RATE)
    INT.ACCRUAL.VAL = DROUND(INT.ACCRUAL.VAL,2)
    GOSUB UPD.APAP.CONTRACT.BAL
    GOSUB LCCY.FCCY.CONV

  END

  RETURN

**********
PRE.CALC:
**********

  IF ACCRUAL.START.DATE AND INT.PAYMENT.DATE THEN
    CALL CDD(REGION.CODE,ACCRUAL.START.DATE,INT.PAYMENT.DATE,COUPON.TENOR)

    Y.NXT.CAL.DAY = TODAY
    CALL CDT('', Y.NXT.CAL.DAY, '+1C')

    YDAY.TYPE = ''
    CALL AWD('',Y.NXT.CAL.DAY,YDAY.TYPE)
    IF YDAY.TYPE EQ 'W' THEN
      CALL CDD(REGION.CODE,ACCRUAL.START.DATE,TODAY,DAYS)
    END ELSE
      Y.CALC.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
      GOSUB CALC.LAST.DAY.OF.MONTH
      DAYS = 'C'
      CALL CDD(REGION.CODE,ACCRUAL.START.DATE,Y.CALC.DAY,DAYS)
    END
    DAYS += 1
  END
  RETURN

************************
CALC.LAST.DAY.OF.MONTH:
************************

  Y.V.DATE.POSN = ''
  Y.NXT.MONTH = Y.CALC.DAY[5,2]
  Y.CUR.MONTH = TODAY[5,2]
  IF Y.CUR.MONTH NE Y.NXT.MONTH THEN
    COMI = TODAY
    CALL LAST.DAY.OF.THIS.MONTH
    Y.CALC.DAY = COMI
    Y.DAYS.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL CDT('',Y.DAYS.DATE,'-1C')
    GOSUB CALC.NEXT.DAY.ACCR
    Y.V.DATE.POSN = INT.ACCRUAL.VAL
  END ELSE
    CALL CDT('', Y.CALC.DAY, '-1C')
  END

  RETURN

********************
CALC.NEXT.DAY.ACCR:
********************

  DAYS = 'C'
  CALL CDD(REGION.CODE,ACCRUAL.START.DATE,Y.DAYS.DATE,DAYS)
  DAYS += 1

  CALC1          = (INTEREST.RATE/100)/BASE
  CALC2          = (CALC1 * COUPON.TENOR)
  CALC3          = (1 + CALC2)

  CALC.EXP1      = (DAYS/COUPON.TENOR)

  CALC4          = PWR(CALC3,CALC.EXP1)
  EFF.RATE       = (CALC4 - 1)
  EFFECTIVE.RATE = EFF.RATE

  INT.ACCRUAL.VAL  = (FACE.VALUE*EFFECTIVE.RATE)
  INT.ACCRUAL.VAL  = DROUND(INT.ACCRUAL.VAL,2)

  RETURN


********************
CALC.AS.OF.STERDAY:
********************

  Y.DAY.BEFORE = TODAY
  CALL CDT('', Y.DAY.BEFORE, '-1C')

  COUPON.TENOR1 = "C"
  DAYS1 = "C"

  CALL CDD(REGION.CODE,ACCRUAL.START.DATE,INT.PAYMENT.DATE,COUPON.TENOR1)

  CALL CDD(REGION.CODE,ACCRUAL.START.DATE,Y.DAY.BEFORE,DAYS1)
  DAYS1 += 1

  CALC1          = ((INTEREST.RATE/100) / BASE)
  CALC2          = (CALC1 * COUPON.TENOR1)
  CALC3          = (1 + CALC2)

  CALC.EXP1      = (DAYS1/COUPON.TENOR1)

  CALC4          = PWR(CALC3,CALC.EXP1)
  EFF.RATE       = (CALC4 - 1)
  EFFECTIVE.RATE1 = EFF.RATE

  INT.ACCRUAL.VAL.STR  = (FACE.VALUE*EFFECTIVE.RATE1)
  INT.ACCRUAL.VAL.STR  = DROUND(INT.ACCRUAL.VAL.STR,2)

  RETURN


STMT.ENTRY:
***************

  INT.ACCRUAL.VAL.LCY = DROUND(INT.ACCRUAL.VAL.LCY,2)
  INT.ACCRUAL.VAL.FCY = DROUND(INT.ACCRUAL.VAL.FCY,2)
  R.SPEC.ENT = ''
  R.SPEC.ENT<AC.STE.ACCOUNT.NUMBER>   = INT.ADJ.ACC
  R.SPEC.ENT<AC.STE.COMPANY.CODE>     = R.SPEC.ENTRY<RE.CSE.COMPANY.CODE>
  R.SPEC.ENT<AC.STE.AMOUNT.LCY>       = INT.ACCRUAL.VAL.LCY
  IF R.SPEC.ENT<AC.STE.AMOUNT.LCY> GT 0 THEN
    R.SPEC.ENT<AC.STE.TRANSACTION.CODE> = Y.SC.CR.TXN.CODE
  END ELSE
    R.SPEC.ENT<AC.STE.TRANSACTION.CODE> = Y.SC.DR.TXN.CODE
  END
  R.SPEC.ENT<AC.STE.PL.CATEGORY>      = ''
  R.SPEC.ENT<AC.STE.CUSTOMER.ID>      = R.SPEC.ENTRY<RE.CSE.CUSTOMER.ID>
  R.SPEC.ENT<AC.STE.PRODUCT.CATEGORY> = R.SPEC.ENTRY<RE.CSE.PRODUCT.CATEGORY>
  R.SPEC.ENT<AC.STE.VALUE.DATE>       = R.SPEC.ENTRY<RE.CSE.VALUE.DATE>
  R.SPEC.ENT<AC.STE.CURRENCY>         = R.SPEC.ENTRY<RE.CSE.CURRENCY>
  IF INT.ACCRUAL.VAL.FCY THEN
    R.SPEC.ENT<AC.STE.AMOUNT.FCY>       = INT.ACCRUAL.VAL.FCY
    R.SPEC.ENT<AC.STE.EXCHANGE.RATE >   = EX.RATE
  END
  R.SPEC.ENT<AC.STE.POSITION.TYPE>    = 'TR'
  R.SPEC.ENT<AC.STE.OUR.REFERENCE>    = R.SPEC.ENTRY<RE.CSE.OUR.REFERENCE>
  R.SPEC.ENT<AC.STE.EXPOSURE.DATE>    = R.SPEC.ENTRY<RE.CSE.EXPOSURE.DATE>
  R.SPEC.ENT<AC.STE.CURRENCY.MARKET>  = R.SPEC.ENTRY<RE.CSE.CURRENCY.MARKET>
  R.SPEC.ENT<AC.STE.TRANS.REFERENCE>  = R.SPEC.ENTRY<RE.CSE.TRANS.REFERENCE>
  R.SPEC.ENT<AC.STE.SYSTEM.ID>        = R.SPEC.ENTRY<RE.CSE.SYSTEM.ID>
  R.SPEC.ENT<AC.STE.BOOKING.DATE>     = R.SPEC.ENTRY<RE.CSE.BOOKING.DATE>

  RETURN

CATEG.ENTRY:
***********

  INT.ACCRUAL.VAL.LCY = DROUND(INT.ACCRUAL.VAL.LCY,2)
  INT.ACCRUAL.VAL.FCY = DROUND(INT.ACCRUAL.VAL.FCY,2)
  R.SPEC.ENT = ''
  R.SPEC.ENT<AC.CAT.COMPANY.CODE>     = R.SPEC.ENTRY<RE.CSE.COMPANY.CODE>
  R.SPEC.ENT<AC.CAT.AMOUNT.LCY>       = INT.ACCRUAL.VAL.LCY * -1
  IF R.SPEC.ENT<AC.CAT.AMOUNT.LCY>  GT 0 THEN
    R.SPEC.ENT<AC.CAT.TRANSACTION.CODE> = Y.SC.CR.TXN.CODE
  END ELSE
    R.SPEC.ENT<AC.CAT.TRANSACTION.CODE> = Y.SC.DR.TXN.CODE
  END
  R.SPEC.ENT<AC.CAT.NARRATIVE,1>      = "DAILY.ACCR"
  R.SPEC.ENT<AC.CAT.PL.CATEGORY>      = INT.PL.CAT
  R.SPEC.ENT<AC.CAT.CUSTOMER.ID>      = R.SPEC.ENTRY<RE.CSE.CUSTOMER.ID>
  R.SPEC.ENT<AC.CAT.PRODUCT.CATEGORY> = R.SPEC.ENTRY<RE.CSE.PRODUCT.CATEGORY>
  R.SPEC.ENT<AC.CAT.VALUE.DATE>       = R.SPEC.ENTRY<RE.CSE.VALUE.DATE>
  R.SPEC.ENT<AC.CAT.CURRENCY>         = R.SPEC.ENTRY<RE.CSE.CURRENCY>
  IF INT.ACCRUAL.VAL.FCY THEN
    R.SPEC.ENT<AC.CAT.AMOUNT.FCY>       = INT.ACCRUAL.VAL.FCY
    R.SPEC.ENT<AC.CAT.EXCHANGE.RATE>    = EX.RATE
  END
  R.SPEC.ENT<AC.CAT.OUR.REFERENCE>    = R.SPEC.ENTRY<RE.CSE.OUR.REFERENCE>
  R.SPEC.ENT<AC.CAT.EXPOSURE.DATE>    = R.SPEC.ENTRY<RE.CSE.EXPOSURE.DATE>
  R.SPEC.ENT<AC.CAT.CURRENCY.MARKET>  = R.SPEC.ENTRY<RE.CSE.CURRENCY.MARKET>
  R.SPEC.ENT<AC.CAT.TRANS.REFERENCE>  = R.SPEC.ENTRY<RE.CSE.TRANS.REFERENCE>
  R.SPEC.ENT<AC.CAT.SYSTEM.ID>        = "SCAC"
  R.SPEC.ENT<AC.CAT.BOOKING.DATE>     = R.SPEC.ENTRY<RE.CSE.BOOKING.DATE>

  RETURN

CALL.EB.ACCOUNTING:
********************

  V = SC.TRP.LAST.COB.TXNS
  ID.NEW = R.SPEC.ENTRY<RE.CSE.TRANS.REFERENCE>
  CALL EB.ACCOUNTING("SC","SAO",Y.COMMON.ARRAY,'')

  RETURN

****************************
UPD.APAP.CONTRACT.BAL:
*****************************

  CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,Y.SEC.TRADE.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,E.REDO.APAP.L.CONTRACT.BALANCES)

  IF R.REDO.APAP.L.CONTRACT.BALANCES THEN
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE,-1>   = TODAY
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE,-1>   = DROUND(EFFECTIVE.RATE*100,4)
    ACCRUE.TO.DATE                                             = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>    = DROUND(INT.ACCRUAL.VAL,2)
    INT.ACCRUAL.VAL                                            = INT.ACCRUAL.VAL - ACCRUE.TO.DATE
    INT.ACCRUAL.VAL                                            = DROUND(INT.ACCRUAL.VAL,2)
    INT.ACCRUAL.VAL                                            = Y.SPEC.AMT  - INT.ACCRUAL.VAL
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT,-1>     = DROUND(INT.ACCRUAL.VAL,2)
    IF TRANS.TYPE EQ 'PURCHASE' THEN
      R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.NOMINAL> = SC.NOMINAL
    END ELSE
      R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.NOMINAL> -= SC.NOMINAL
    END
  END ELSE
    GOSUB CALC.AS.OF.STERDAY
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE> = DROUND(INT.ACCRUAL.VAL,2)
    INT.ACCRUAL.VAL                                         = INT.ACCRUAL.VAL - INT.ACCRUAL.VAL.STR
    INT.ACCRUAL.VAL                                         = DROUND(INT.ACCRUAL.VAL,2)
    INT.ACCRUAL.VAL                                         = Y.SPEC.AMT - INT.ACCRUAL.VAL
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE>   = TODAY
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE>   = DROUND(EFFECTIVE.RATE*100,4)
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT>     = DROUND(INT.ACCRUAL.VAL,2)
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.NOMINAL> = SC.NOMINAL
  END

  CALL F.WRITE(FN.REDO.APAP.L.CONTRACT.BALANCES,Y.SEC.TRADE.ID,R.REDO.APAP.L.CONTRACT.BALANCES)

  IF INT.ACCRUAL.VAL EQ 0 THEN
    Y.PROCESS.GOHEAD = @FALSE
  END
  RETURN

*****************
LCCY.FCCY.CONV:
*****************

  INT.ACCRUAL.VAL.FCY = ''
  INT.ACCRUAL.VAL.LCY = ''

  IF Y.SEC.CCY EQ LCCY THEN
    INT.ACCRUAL.VAL.LCY = INT.ACCRUAL.VAL
    INT.ACCRUAL.VAL.FCY = ''
  END

  IF Y.SEC.CCY NE LCCY THEN
    INT.ACCRUAL.VAL.FCY = INT.ACCRUAL.VAL
    CCY.MARKET = Y.CCY.MARKET
    FCY.TXN.CCY = Y.SEC.CCY
    FCY.TXN.AMOUNT = INT.ACCRUAL.VAL
    AML.CCY = LCCY
    SELL.AMT = ""
    DIFF.AMT = ''
    LCCY.AMT = ''
    RET.ERR = ''
    EX.RATE = ''
    CALL EXCHRATE(CCY.MARKET,FCY.TXN.CCY,FCY.TXN.AMOUNT,AML.CCY,SELL.AMT,'',EX.RATE,DIFF.AMT,LCCY.AMT,RET.ERR)
    INT.ACCRUAL.VAL.LCY = LCCY.AMT
  END

  RETURN

******************
UPD.L.SC.ENTRIES:
******************

  RETURN

END
