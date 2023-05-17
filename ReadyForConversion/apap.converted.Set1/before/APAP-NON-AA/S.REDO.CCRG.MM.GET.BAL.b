*-----------------------------------------------------------------------------
* <Rating>-67</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.MM.GET.BAL(P.CONTRACT.ID, R.MM, P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program get the balances for the contract in ARRANGEMENT application
*
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*               PARAMETER in REDO.CCRG.PARAMETERS field P.EVALUATOR.RTN
*
* In Parameter:
*               P.CONTRACT.ID    (in)  Contranct Id.
*               R.MM             (in)  Record of the contract in process
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 18/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              anoriega@temenos.com
* 14/07/2011 - ODR-2011-03-0154
*              Modifications for calculate the local currency
*              avelasco@temenos.com
*REM Just for compile
*--------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_F.CURRENCY
*
$INSERT I_REDO.CCRG.CONSTANT.COMMON
*
*--------------------------------------------------------------------------------------------
*

  GOSUB INITIALISE
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------


*Initialise
  Y.DB = 0
  Y.RB = 0
  Y.CB = 0

*Get Direct Balance
  Y.DB = R.MM<MM.PRINCIPAL>

*Get Contingent Balance
  Y.CB = R.MM<MM.BROKER.AMOUNT>

*Get Interes Receivable
  Y.INT.PERIOD.END = R.MM<MM.INT.PERIOD.END>
  CALL CDD('',Y.INT.PERIOD.END,TODAY,NO.OF.DAYS)
  IF NO.OF.DAYS LE 90 THEN
    Y.RB = R.MM<MM.TOT.INTEREST.AMT>
  END
* Is Local currency
  IF LCCY NE Y.CURRENCY.CONTRACT THEN
    Y.CURRENCY.ID = Y.CURRENCY.CONTRACT
    GOSUB GET.RATE
    Y.DB = Y.DB * Y.REV.RATE
    Y.CB = Y.CB * Y.REV.RATE
    CALL EB.ROUND.AMOUNT(LCCY, Y.DB, "", "")
    CALL EB.ROUND.AMOUNT(LCCY, Y.CB, "", "")
  END
  IF LCCY NE Y.CURRENCY.INT THEN
    Y.CURRENCY.ID = Y.CURRENCY.INT
    GOSUB GET.RATE
    Y.RB = Y.RB * Y.REV.RATE
    CALL EB.ROUND.AMOUNT(LCCY, Y.RB, "", "")
  END
*Balances to send go out
  P.RETURN<1> = ABS(Y.DB)
  P.RETURN<2> = ABS(Y.RB)
  P.RETURN<3> = ABS(Y.CB)

  RETURN

*--------------------------------------------------------------------------------------------
GET.RATE:
*--------------------------------------------------------------------------------------------
*avelasco - New call to S.REDO.CONV.LOCAL.CURR to get the MID.REVAL.RATE
* Get Rate
  Y.REV.RATE = ''
  CALL S.REDO.CONV.LOCAL.CURR(Y.CURRENCY.ID,1,Y.REV.RATE)
  IF NOT(Y.REV.RATE) THEN
    E = 'ST-REDO.CCRG.MID.REVAL.RATE.NO.DEF'  : FM : "CURRENCY:": VM :Y.CURRENCY.ID
    PROCESS.GOAHEAD = @FALSE
  END

  RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

  LOOP.CNT          = 1
  MAX.LOOPS         = 3
  PROCESS.GOAHEAD   = @TRUE
  P.RETURN          = ''

  Y.CURRENCY.CONTRACT  = R.MM<MM.CURRENCY>
  Y.CURRENCY.INT     = R.MM<MM.INT.CCY>

  RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

  MAX.LOOPS = 2
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
      IF NOT(P.CONTRACT.ID) THEN
        E = K.PARAMETER.IS.EMPTY : FM : "P.CONTRACT.ID" : VM : "S.REDO.CCRG.MM.GET.BAL"
        PROCESS.GOAHEAD = @FALSE
      END
    CASE LOOP.CNT EQ 2
      IF NOT(R.MM) THEN
        E = K.PARAMETER.IS.EMPTY : FM : "R.MM" : VM : "S.REDO.CCRG.MM.GET.BAL"
        PROCESS.GOAHEAD = @FALSE
      END
    END CASE

    LOOP.CNT +=1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------

END
