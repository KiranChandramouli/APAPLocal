*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.V.CHANNEL
**
* Subroutine Type : VERSION
* Attached to     : REDO.LY.MODALITY,CREATE
* Attached as     : Field CHANNEL as VALIDATION.RTN
* Primary Purpose : Populate the field APP.TXN based on any value selected in
*                   field CHANNEL
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 7/10/11 - First Version
*           ODR Reference: ODR-2011-06-0243
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
* 16/11/11 - Update
*            ODR Reference: ODR-2011-06-0243
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.LY.MODALITY

  Y.TYPE = R.NEW(REDO.MOD.TYPE)

  IF VAL.TEXT THEN
    Y.CHANNEL = R.NEW(REDO.MOD.CHANNEL)
    GOSUB VAL.CH
  END ELSE
    Y.CHANNEL = COMI
    GOSUB PROCESS
  END

  RETURN

********
PROCESS:
********

  Y.APP.TXN = 'FT'

  IF Y.CHANNEL EQ 'TT' THEN
    Y.APP.TXN = 'TT'
  END

  IF Y.TYPE EQ '1' AND Y.CHANNEL NE '' THEN
    Y.NEW.VAL = DCOUNT(R.NEW(REDO.MOD.APP.TXN),VM)
    R.NEW(REDO.MOD.APP.TXN)<1,Y.NEW.VAL> = Y.APP.TXN
    T(REDO.MOD.EVENT)<3> = 'NOINPUT'
    T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
    T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'
*        T(REDO.MOD.CURRENCY)<3> = 'NOINPUT'
  END

  RETURN

*******
VAL.CH:
*******

  IF Y.TYPE EQ '1' AND Y.CHANNEL EQ '' THEN
    AF = REDO.MOD.CHANNEL
    ETEXT = 'EB-REDO.CHECK.FIELDS':FM:Y.TYPE
    CALL STORE.END.ERROR
  END

  GOSUB VAL.TXN.CODE

  RETURN

*************
VAL.TXN.CODE:
*************

  Y.TXN.CODE = R.NEW(REDO.MOD.TXN.CODE)

  T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'

  IF Y.TYPE EQ '1' AND Y.CHANNEL NE '' AND Y.TXN.CODE EQ '' THEN
    COMI = ''
    AF = REDO.MOD.TXN.CODE
    ETEXT = 'EB-REDO.CHECK.FIELDS':FM:Y.TYPE
    CALL STORE.END.ERROR
  END

  RETURN

END
