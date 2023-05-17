*-----------------------------------------------------------------------------
* <Rating>-112</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.SYSTEM.ID
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is conversion routine used to fetch the value of the local field
* L.NCF.NUMBER based on the application
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                   Reference              Description
* 22-MAR-2011    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.DATA.CAPTURE
$INSERT I_F.FOREX
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_F.DD.DDI

  GOSUB INIT
  GOSUB GET.LT.DETS
  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------------
INIT:
*-------
* Initialise/Open all necessary files/Variables

  Y.REFERENCE = ''
  Y.DC.POS = ''
  Y.MM.POS = ''
  Y.FT.POS = ''
  Y.FX.POS = ''
  Y.TT.POS = ''
  Y.DD.POS = ''
  Y.LT.VALUE = ''
  FN.TELLER = 'F.TELLER'
  F.TELLER = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.HIS = 'F.TELLER$HIS'
  F.TELLER.HIS = ''
  CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

  FN.MONEY.MARKET = 'F.MM.MONEY.MARKET'
  F.MONEY.MARKET = ''
  CALL OPF(FN.MONEY.MARKET,F.MONEY.MARKET)

  FN.MONEY.MARKET.HIS = 'F.MM.MONEY.MARKET$HIS'
  F.MONEY.MARKET.HIS = ''
  CALL OPF(FN.MONEY.MARKET.HIS,F.MONEY.MARKET.HIS)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIS = ''
  CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

  FN.FOREX = 'F.FOREX'
  F.FOREX = ''
  CALL OPF(FN.FOREX,F.FOREX)

  FN.FOREX.HIS = 'F.FOREX$HIS'
  F.FOREX.HIS = ''
  CALL OPF(FN.FOREX.HIS,F.FOREX.HIS)

  FN.DATA.CAPTURE = 'F.DATA.CAPTURE'
  F.DATA.CAPTURE = ''
  CALL OPF(FN.DATA.CAPTURE,F.DATA.CAPTURE)

  FN.DATA.CAPTURE.HIS = 'F.DATA.CAPTURE$HIS'
  F.DATA.CAPTURE.HIS = ''
  CALL OPF(FN.DATA.CAPTURE.HIS,F.DATA.CAPTURE.HIS)

  FN.DD = 'F.DD.DDI'
  F.DD = ''
  CALL OPF(FN.DD,F.DD)

  FN.DD.HIS = 'F.DD.DDI$HIS'
  F.DD.HIS = ''
  CALL OPF(FN.DD.HIS,F.DD.HIS)

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*-------------
  Y.VAL = O.DATA
  Y.APPL = FIELD(Y.VAL,'.',1)
  Y.REFERENCE = FIELD(Y.VAL,'.',2)
  Y.FLAG = ''
  Y.LT.VALUE = ''
  BEGIN CASE
  CASE Y.APPL EQ 'DC' AND Y.FLAG EQ ''
    GOSUB PROCESS.DC
  CASE Y.APPL EQ 'MM' AND Y.FLAG EQ ''
    GOSUB PROCESS.MM
  CASE Y.APPL EQ 'FT' AND Y.FLAG EQ ''
    GOSUB PROCESS.FT
  CASE Y.APPL EQ 'FX' AND Y.FLAG EQ ''
    GOSUB PROCESS.FX
  CASE Y.APPL EQ 'TT' AND Y.FLAG EQ ''
    GOSUB PROCESS.TT
  CASE Y.APPL EQ 'DD' AND Y.FLAG EQ ''
    GOSUB PROCESS.DD
  END CASE
  IF Y.LT.VALUE NE '' THEN
    O.DATA = '-':Y.LT.VALUE
  END ELSE
    O.DATA = ''
  END
  RETURN

*---------------------------------------------------------------------------------
PROCESS.DC:
*-----------

  CALL F.READ(FN.DATA.CAPTURE,Y.REFERENCE,R.DC,F.DATA.CAPTURE,DC.ERR)
  IF R.DC EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.DATA.CAPTURE.HIS,Y.REFERENCE,R.DC,DC.ER.HIS)
  END
  Y.LT.VALUE = R.DC<DC.DC.LOCAL.REF,Y.DC.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
PROCESS.MM:
*-------------

  CALL F.READ(FN.MONEY.MARKET,Y.REFERENCE,R.MM,F.MONEY.MARKET,MM.ERR)
  IF R.MM EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.MONEY.MARKET.HIS,Y.REFERENCE,R.MM,MM.ERR.HIS)
  END
  Y.LT.VALUE = R.MM<MM.LOCAL.REF,Y.MM.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
PROCESS.FT:
*------------

  CALL F.READ(FN.FUNDS.TRANSFER,Y.REFERENCE,R.FT,F.FUNDS.TRANSFER,FT.ERR)
  IF R.FT EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.REFERENCE,R.FT,FT.ERR.HIS)
  END
  Y.LT.VALUE = R.FT<FT.LOCAL.REF,Y.FT.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
PROCESS.FX:
*------------

  CALL F.READ(FN.FOREX,Y.REFERENCE,R.FX,F.FOREX,FX.ERR)
  IF R.FX EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.FOREX.HIS,Y.REFERENCE,R.FX,FX.ERR.HIS)
  END
  Y.LT.VALUE = R.FX<FX.LOCAL.REF,Y.FX.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
PROCESS.TT:
*------------

  CALL F.READ(FN.TELLER,Y.REFERENCE,R.TT,F.TELLER,TT.ERR)
  IF R.TT EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.REFERENCE,R.TT,TT.ERR.HIS)
  END
  Y.LT.VALUE = R.TT<TT.TE.LOCAL.REF,Y.TT.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
PROCESS.DD:
*-------------

  CALL F.READ(FN.DD,Y.REFERNECE,R.DD,F.DD,DD.ERR)
  IF R.DD EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.DD.HIS,Y.REFERNECE,R.DD,DD.ERR.HIS)
  END
  Y.LT.VALUE = R.DD<DD.DDI.LOCAL.REF,Y.DD.POS>
  Y.FLAG = 1
  RETURN

*---------------------------------------------------------------------------------
GET.LT.DETS:
*--------------
* calls the core routine MULTI.GET.LOC.REF and fetches the value of the local field position

  APPL.NAME = 'DATA.CAPTURE':FM:'MM.MONEY.MARKET':FM:'FUNDS.TRANSFER':FM:'FOREX':FM:'TELLER':FM:'DD.DDI'
  FLD.NAME = 'L.NCF.NUMBER':FM:'L.NCF.NUMBER':FM:'L.NCF.NUMBER':FM:'L.NCF.NUMBER':FM:'L.NCF.NUMBER':FM:'L.NCF.NUMBER'
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
  Y.DC.POS = FLD.POS<1,1>
  Y.MM.POS = FLD.POS<2,1>
  Y.FT.POS = FLD.POS<3,1>
  Y.FX.POS = FLD.POS<4,1>
  Y.TT.POS = FLD.POS<5,1>
  Y.DD.POS = FLD.POS<6,1>

  RETURN
*---------------------------------------------------------------------------------
END
