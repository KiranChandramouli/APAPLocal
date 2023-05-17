*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.ST.EFF.RATE(Y.ARR)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This NOFILE routine should be attached to the below ENQUIRY REDO.SEC.TRADE.EFF.RATE
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NaveenKumar N
* PROGRAM NAME : REDO.V.AUT.EFF.RATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference          Description
* 14-Oct-2010      NaveenKumar N      ODR-2010-07-0081   Initial creation
* 04-May-2011      Pradeep S          PACS00056287       Effective rate calculation changed
*------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.SEC.TRADE
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.REDO.H.ST.SUB.ASSET.TYPE
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  GOSUB INIT
  GOSUB PROCESS
*Y.ARR = Y.DATE:"*":Y.SC.EFF.RATE
  RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*****
INIT:
*****
*
  FN.SEC.TRADE       = "F.SEC.TRADE"
  F.SEC.TRADE        = ""
  R.SEC.TRADE        = ""
  E.SEC.TRADE        = ""

  Y.ARR = ''
  Y.DATE = ''
  Y.SC.EFF.RATE = ''

  Y.APPL = "SEC.TRADE"
  Y.FLD = "L.DISC.AMOUNT"
  Y.FLD.POS = ''

  CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.FLD.POS)
  Y.DIS.AMT.POS = Y.FLD.POS

  CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
*
  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
********
PROCESS:
********
*
  SEC.TRADE.ID       = "" ; VALUE.DATE         = "" ; MATURITY.DATE      = "" ; Y.ARR = "" ;  Y.DATE = "" ; Y.ACTUAL = "" ;
  Y.FROM.DATE = '' ; Y.TO.DATE = '' ; Y.TILL.MAT = ''
*
  LOCATE "SEC.TRADE.ID" IN D.FIELDS<1> SETTING POSITION.ONE THEN
    SEC.TRADE.ID   = D.RANGE.AND.VALUE<POSITION.ONE>
  END

  LOCATE "FROM.DATE" IN D.FIELDS<1> SETTING FROM.POS THEN
    Y.FROM.DATE   = D.RANGE.AND.VALUE<FROM.POS>
  END

  LOCATE "TO.DATE" IN D.FIELDS<1> SETTING TO.POS THEN
    Y.TO.DATE   = D.RANGE.AND.VALUE<TO.POS>
  END

  LOCATE "TILL.MAT" IN D.FIELDS<1> SETTING MAT.POS THEN
    Y.TILL.MAT   = D.RANGE.AND.VALUE<MAT.POS>
  END

  CALL F.READ(FN.SEC.TRADE,SEC.TRADE.ID,R.SEC.TRADE,F.SEC.TRADE,E.SEC.TRADE)
  IF NOT(R.SEC.TRADE) THEN
    RETURN
  END

  VALUE.DATE         = R.SEC.TRADE<SC.SBS.VALUE.DATE>
  MATURITY.DATE      = R.SEC.TRADE<SC.SBS.MATURITY.DATE>
  Y.DISC.AMT = R.SEC.TRADE<SC.SBS.LOCAL.REF,Y.DIS.AMT.POS>
  Y.DISC.AMT = TRIM(Y.DISC.AMT,' ',"B")
  Y.FACE.VALUE = R.SEC.TRADE<SC.SBS.CUST.NO.NOM>

  GOSUB CHECK.DATES
  GOSUB SET.FROM.TO.DATE

  Y.NO.OF.DAYS       = 'C'
  IF VALUE.DATE NE '' AND MATURITY.DATE NE '' THEN
    CALL CDD('',VALUE.DATE,MATURITY.DATE,Y.NO.OF.DAYS)
  END
  Y.CNT              = "1"
  LOOP
  WHILE Y.CNT LE Y.NO.OF.DAYS

    Y.DAYS.DIV.COUP = Y.CNT/Y.NO.OF.DAYS
    Y.PD.BY.FC = 1 + (Y.DISC.AMT / Y.FACE.VALUE)
    Y.EFF.RATE = (PWR(Y.PD.BY.FC,Y.DAYS.DIV.COUP) - 1) * 100

    Y.ACCR.AMT = (Y.EFF.RATE * Y.FACE.VALUE) / 100
    Y.PENDING.AMORT = Y.DISC.AMT - Y.ACCR.AMT

    IF Y.CNT EQ 1 THEN
      Y.MARGINAL = Y.ACCR.AMT
      Y.DATE = VALUE.DATE
    END ELSE
      NEXT.DATE      = '1D'
      CALL CALENDAR.DAY(VALUE.DATE,'+',NEXT.DATE)
      Y.DATE = NEXT.DATE
      VALUE.DATE     = NEXT.DATE
      Y.MARGINAL = Y.ACCR.AMT - Y.ACCR.AMT.LAST
    END

    IF Y.DATE GE Y.FROM.DATE AND Y.DATE LE Y.TO.DATE THEN
      Y.ARR<-1> = Y.DATE:"*":Y.EFF.RATE:"*":Y.ACCR.AMT:"*":Y.PENDING.AMORT:"*":Y.MARGINAL
    END

    Y.ACCR.AMT.LAST = Y.ACCR.AMT

    Y.CNT++
  REPEAT
  RETURN

************
CHECK.DATES:
************

  IF Y.TO.DATE AND Y.TO.DATE GT MATURITY.DATE THEN
    ENQ.ERROR = "EB-TO.DATE.GT.MAT.DATE"
  END

  IF Y.TO.DATE AND Y.TO.DATE LT VALUE.DATE THEN
    ENQ.ERROR = "EB-TO.DATE.LT.VAL.DATE"
  END

  IF Y.FROM.DATE AND Y.FROM.DATE GT MATURITY.DATE THEN
    ENQ.ERROR = "EB-FROM.DATE.GT.MAT.DATE"
  END

  IF Y.FROM.DATE AND Y.FROM.DATE LT VALUE.DATE THEN
    ENQ.ERROR = "EB-FROM.DATE.LT.VAL.DATE"
  END

  RETURN

******************
SET.FROM.TO.DATE:
******************

  BEGIN CASE

  CASE Y.FROM.DATE NE '' AND Y.TO.DATE EQ ''

    IF Y.TILL.MAT EQ "YES" THEN
      Y.TO.DATE = MATURITY.DATE
    END ELSE
      IF Y.FROM.DATE LT TODAY THEN
        Y.TO.DATE = TODAY
      END ELSE
        Y.TO.DATE = MATURITY.DATE
      END
    END

  CASE Y.FROM.DATE EQ '' AND Y.TO.DATE NE ''
    IF Y.TILL.MAT EQ "YES" THEN
      Y.FROM.DATE = VALUE.DATE
    END ELSE
      IF Y.TO.DATE LT TODAY THEN
        Y.FROM.DATE = TODAY
      END ELSE
        Y.FROM.DATE = VALUE.DATE
      END
    END

  CASE Y.FROM.DATE EQ ''  AND Y.TO.DATE EQ ''

    IF Y.TILL.MAT EQ "YES" THEN
      Y.FROM.DATE = VALUE.DATE
      Y.TO.DATE = MATURITY.DATE
    END ELSE
      Y.FROM.DATE = VALUE.DATE
      Y.TO.DATE = TODAY
    END

  END CASE

  RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
END
