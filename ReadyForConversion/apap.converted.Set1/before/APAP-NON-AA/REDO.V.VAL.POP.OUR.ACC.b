*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.POP.OUR.ACC
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Riyas
* Program Name  : REDO.V.VAL.POP.OUR.ACC
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : This VALIDATION routine is used to populate our accounts
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date            Author              Reference         Description
*----------------------------------------------------------------------------------
* 20-Nov-2013     Vignesh Kumaar R    PACS00325160      FX POSITION BUY/SELL CCY VALIDATION
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.ACCOUNT.CLASS
$INSERT I_GTS.COMMON

  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------
  FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
  F.ACCOUNT.CLASS  = ''
  CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

  Y.FX.CR.ID = 'SUSPFXCR'
  Y.FX.DR.ID = 'SUSPFXDR'

  CALL F.READ(FN.ACCOUNT.CLASS,Y.FX.CR.ID,R.ACCOUNT.CLASS,F.ACCOUNT.CLASS,ACCOUNT.CLASS.ERR)
  Y.FX.CR.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>

  CALL F.READ(FN.ACCOUNT.CLASS,Y.FX.DR.ID,R.ACCOUNT.CLASS,F.ACCOUNT.CLASS,ACCOUNT.CLASS.ERR)
  Y.FX.DR.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>

  RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  Y.COMI = COMI

  IF OFS$HOT.FIELD EQ 'CURRENCY.BOUGHT' THEN
    IF Y.COMI EQ 'DOP' AND (PGM.VERSION EQ ',REDO.SPOT.BUY' OR PGM.VERSION EQ ',REDO.FORWARD.BUY') THEN
      COMI = ''
      ETEXT = "EB-REDO.BUY.CCY.NO.DOP"
      CALL STORE.END.ERROR
    END ELSE
      R.NEW(FX.OUR.ACCOUNT.REC) = Y.COMI:Y.FX.CR.CATEG:'0001'
    END
  END
  IF OFS$HOT.FIELD EQ 'CURRENCY.SOLD' THEN
    IF Y.COMI EQ 'DOP' AND (PGM.VERSION EQ ',REDO.SPOT.SELL' OR PGM.VERSION EQ ',REDO.FORWARD.SELL') THEN
      COMI = ''
      ETEXT = "EB-REDO.SELL.CCY.NO.DOP"
      CALL STORE.END.ERROR
    END ELSE
      R.NEW(FX.OUR.ACCOUNT.PAY) = Y.COMI:Y.FX.DR.CATEG:'0001'
    END
  END

  RETURN
END
