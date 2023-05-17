*-----------------------------------------------------------------------------
* <Rating>-73</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.POOL.RATE
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is Input Routine attached in version control of FOREX
* This routine will be used to populate the POOL.RATE in the FOREX application
* for the CURRENCY MARKET - 19
*
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference           Description
* 09-AUG-10    Kishore.SP            INITIALVERSION
* 21-Jul-11    Pradeep S             PACS00082438          Pool Rate value will not be re-calculated for FX
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.CURRENCY
$INSERT I_F.REDO.CCY.MKT.FXSN
*-----------------------------------------------------------------------------

  GOSUB INTIALISE
  GOSUB CHECK.VALUE
  RETURN
*-----------------------------------------------------------------------------
INTIALISE:
*---------
* open the needed files and get the local field position
!
  FN.FOREX = 'F.FOREX'
  F.FOREX  = ''
  CALL OPF(FN.FOREX,F.FOREX)
!
  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)
!
  FN.REDO.CCY.MKT.FXSN = 'F.REDO.CCY.MKT.FXSN'
  F.REDO.CCY.MKT.FXSN = ''
  R.REDO.CCY.MKT.FXSN = ''
  REDO.CCY.MKT.FXSN.ERR = ''
  *CALL OPF(FN.REDO.CCY.MKT.FXSN,F.REDO.CCY.MKT.FXSN) ;*Tus S/E 

  LOC.REF.APPL="FOREX"
  LOC.REF.FIELDS="L.FX.POOL.RATE"
  LOC.REF.POS=" "
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.PL.RT.POS   =  LOC.REF.POS<1,1>
!
  RETURN
*-----------------------------------------------------------------------------
CHECK.VALUE:
*-----------
* Get the deal type
* if the value is other than "SP" and "FW" it returns

  Y.DEAL.TYPE = R.NEW(FX.DEAL.TYPE)
!
*PACS00082438 - S
  Y.POOL.RATE = R.NEW(FX.LOCAL.REF)<1,Y.PL.RT.POS>
  IF Y.POOL.RATE NE '' THEN
    RETURN
  END
*PACS00082438 - E


  IF Y.DEAL.TYPE EQ 'SP' OR Y.DEAL.TYPE EQ 'FW' THEN
    Y.BUY.CCY   = R.NEW(FX.CURRENCY.BOUGHT)
    Y.SELL.CCY  = R.NEW(FX.CURRENCY.SOLD)

    CALL CACHE.READ(FN.REDO.CCY.MKT.FXSN,"SYSTEM",R.REDO.CCY.MKT.FXSN,REDO.CCY.MKT.FXSN.ERR)

    CCY.MKT.CODES = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT.CODE>
    CHANGE VM TO FM IN CCY.MKT.CODES

    LOCATE "FX.POOL.RATE" IN CCY.MKT.CODES SETTING FX.TR.POS THEN
      Y.CURR.MARK = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT,FX.TR.POS>
    END

    GOSUB CHECK.BUY.CCY
    GOSUB CHECK.SELL.CCY
  END
  RETURN
*-----------------------------------------------------------------------------
CHECK.BUY.CCY:
*-------------
* LCCY is the local currency
* if it is local currency it returns
!
  IF Y.BUY.CCY NE LCCY THEN
    R.Y.BUY.CCY = ''
    CALL F.READ(FN.CURRENCY,Y.BUY.CCY,R.Y.BUY.CCY,F.CURRENCY,Y.ERR.BCCY)
    IF R.Y.BUY.CCY NE '' THEN
      Y.CURRENCY.MARKET = R.Y.BUY.CCY<EB.CUR.CURRENCY.MARKET>
      GOSUB CHECK.BCCY.MARKET
    END
  END
  RETURN
*-----------------------------------------------------------------------------
CHECK.BCCY.MARKET:
*-----------------
* locate the currecny market of the forex in currency table
* Get the corresponding buy rate and update in the local field POOL.RATE

  LOCATE Y.CURR.MARK IN Y.CURRENCY.MARKET<1,1> SETTING Y.BUY.POS THEN
    Y.BUY.RATE = R.Y.BUY.CCY<EB.CUR.BUY.RATE,Y.BUY.POS>
    R.NEW(FX.LOCAL.REF)<1,Y.PL.RT.POS> = Y.BUY.RATE
  END
!
  RETURN
*-----------------------------------------------------------------------------
CHECK.SELL.CCY:
*---------------
* LCCY is the local currency
* if it is local currency it returns
!
  IF Y.SELL.CCY NE LCCY THEN
    R.Y.SELL.CCY = ''
    CALL F.READ(FN.CURRENCY,Y.SELL.CCY,R.Y.SELL.CCY,F.CURRENCY,Y.ERR.BCCY)
    IF R.Y.SELL.CCY NE '' THEN
      Y.CURRENCY.MARKET = R.Y.SELL.CCY<EB.CUR.CURRENCY.MARKET>
      GOSUB CHECK.SCCY.MARKET
    END
  END
!
  RETURN
*-----------------------------------------------------------------------------
CHECK.SCCY.MARKET:
*-----------------
* locate the currecny market of the forex in currency table
* Get the corresponding sell rate and update in the local field POOL.RATE
!
  LOCATE Y.CURR.MARK IN Y.CURRENCY.MARKET<1,1> SETTING Y.SEL.POS THEN
    Y.SELL.RATE = R.Y.SELL.CCY<EB.CUR.SELL.RATE,Y.SEL.POS>
    R.NEW(FX.LOCAL.REF)<1,Y.PL.RT.POS> = Y.SELL.RATE
  END
!
  RETURN
*-----------------------------------------------------------------------------
END
