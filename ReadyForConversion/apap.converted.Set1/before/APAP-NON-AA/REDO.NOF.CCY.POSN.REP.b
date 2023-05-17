*-----------------------------------------------------------------------------
* <Rating>-71</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.CCY.POSN.REP(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : A C Rajkumar
* Program Name  : REDO.NOF.CCY.POSN.REP
* ODR NUMBER    : ODR-2010-08-0422
*----------------------------------------------------------------------------------
* Description   : This is a nofile routine used to fetch the details and display
*                 it in report format
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
*    Date           Author          Reference           Description
* 05-Nov-2010    A C Rajkumar   ODR-2010-08-0430      Initial creation
*-----------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.FX.CCY.POSN
*
  GOSUB OPEN.PARA
  GOSUB LOCATE.IDS
  GOSUB SEL.LIST
*
  RETURN
*
*=========
OPEN.PARA:
*=========
*
  FN.REDO.FX.CCY.POSN = 'F.REDO.FX.CCY.POSN'
  F.REDO.FX.CCY.POSN  = ''
  CALL OPF(FN.REDO.FX.CCY.POSN, F.REDO.FX.CCY.POSN)
*
  RETURN
*
*==========
LOCATE.IDS:
*==========
*
  LOCATE "INITIAL.DATE" IN D.FIELDS<1> SETTING INIT.POS THEN
    Y.INIT.DATE = D.RANGE.AND.VALUE<INIT.POS>
  END

  LOCATE "FINAL.DATE" IN D.FIELDS<1> SETTING FIN.POS THEN
    Y.FIN.DATE = D.RANGE.AND.VALUE<FIN.POS>
  END

  LOCATE "CURRENCY" IN D.FIELDS<1> SETTING CCY.POS THEN
    Y.CCY = D.RANGE.AND.VALUE<CCY.POS>
    Y.LCCY.TEMP = LCCY
    IF Y.CCY EQ Y.LCCY.TEMP THEN
      ENQ.ERROR = 'EB-CCY.LOCAL.ERR'
    END
  END
*
  RETURN
*
*========
SEL.LIST:
*========
*
  Y.COUNT.ARR = ''
*
  SEL.CMD = "SELECT ":FN.REDO.FX.CCY.POSN:" WITH @ID GE ":Y.CCY:Y.INIT.DATE:" AND LE ":Y.CCY:Y.FIN.DATE:" BY @ID"
  CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.REC, Y.SEL.ERR)

  SEL.CMD.TEMP = "SELECT ":FN.REDO.FX.CCY.POSN:" BY @ID"
  CALL EB.READLIST(SEL.CMD.TEMP, SEL.LIST.TEMP, '', NO.OF.REC.TEMP, Y.SEL.ERR.TEMP)

  LOOP
    REMOVE Y.ID FROM SEL.LIST SETTING Y.POS
  WHILE Y.ID:Y.POS


    GOSUB PREV.DATE.POSN

    GOSUB FETCH.DETS

    Y.ID  = Y.ID[4,11]
    Y.ID  = Y.ID[5,2]:'/':Y.ID[7,2]:'/':Y.ID[1,4]

    Y.COUNT.ARR ++
    Y.FINAL.ARRAY<-1> = Y.ID:'*':Y.TOTAL.POSN:'*':Y.TOT.BOUGHT:'*':Y.TOT.SOLD:'*':Y.FINAL.POSN:'*':Y.AVG.BUY.RATE:'*':Y.AVG.SELL.RATE:'*':Y.SPREAD:'*':Y.DAILY.PL:'*':Y.COUNT.ARR

  REPEAT
*
  RETURN
*
*==========
FETCH.DETS:
*==========
*
  CALL F.READ(FN.REDO.FX.CCY.POSN, Y.ID, R.REDO.FX.CCY.POSN, F.REDO.FX.CCY.POSN, Y.ERR.REDO.FX.CCY.POSN)

  Y.TOT.BOUGHT     = R.REDO.FX.CCY.POSN<REDO.FX.BUY.POSITION>
  Y.TOT.SOLD       = R.REDO.FX.CCY.POSN<REDO.FX.SELL.POSITION>
  Y.AVG.BUY.RATE   = R.REDO.FX.CCY.POSN<REDO.FX.WGT.BUY.AVG>
  Y.AVG.SELL.RATE  = R.REDO.FX.CCY.POSN<REDO.FX.WGT.SELL.AVG>

  Y.SPREAD         = Y.AVG.SELL.RATE - Y.AVG.BUY.RATE
  Y.DAILY.PL       = Y.TOT.SOLD * Y.SPREAD
  Y.FINAL.POSN     = Y.TOTAL.POSN + Y.TOT.BOUGHT - Y.TOT.SOLD
*
  RETURN
*
*================
PREV.DATE.POSN:
*================
*
  LOCATE Y.ID IN SEL.LIST.TEMP SETTING Y.PREV.POSN THEN
    IF Y.PREV.POSN THEN
      Y.PREV.ID = SEL.LIST.TEMP<Y.PREV.POSN - 1>
    END
  END

  CALL F.READ(FN.REDO.FX.CCY.POSN, Y.PREV.ID, R.REDO.FX.CCY.POSN.TOT, F.REDO.FX.CCY.POSN, Y.ERR.REDO.FX.CCY.POSN.TOT)

  Y.TOTAL.POSN = R.REDO.FX.CCY.POSN.TOT<REDO.FX.TOTAL.POSN>

  RETURN

*============
*PROGRAM END
*============
