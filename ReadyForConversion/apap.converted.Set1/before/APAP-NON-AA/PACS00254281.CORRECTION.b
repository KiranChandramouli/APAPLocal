*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE PACS00254281.CORRECTION

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PRINT.CHQ.LIST

*----------------------------------------------------------------------
*MODIFICATION DETAILS:
*---------------------
*   DATE       RESOURCE           REFERENCE             DESCRIPTION
* 20-03-2013   Arundev      PACS00254281 RTC-612021   Correction routine to updated wordings in existing records
*                                                     El campo VALOR EN LETRAS debis mostrar el valor MIL no UN MIL"
*                                                     En un cheque emitido sslo con valor de centavos el campo
*                                                     VALOR EN LETRAS debe decir iniciar con CERO PESOS
*----------------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------

  RETURN

*----------------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------------

  FN.REDO.PRINT.CHQ.LIST = 'F.REDO.PRINT.CHQ.LIST'
  F.REDO.PRINT.CHQ.LIST = ''
  CALL OPF(FN.REDO.PRINT.CHQ.LIST,F.REDO.PRINT.CHQ.LIST)

  RETURN

*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------

  SEL.LIST = ''
  SEL.CMD = 'SELECT ':FN.REDO.PRINT.CHQ.LIST
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'','','')

  POS1 = ''
  LOOP
    REMOVE PRINT.CHQ.LIST.ID FROM SEL.LIST SETTING POS1
  WHILE PRINT.CHQ.LIST.ID:POS1
    R.PRINT.CHQ.LIST = ''
    PRINT.CHQ.LIST.ERR = ''
    CALL F.READ(FN.REDO.PRINT.CHQ.LIST,PRINT.CHQ.LIST.ID,R.PRINT.CHQ.LIST,F.REDO.PRINT.CHQ.LIST,PRINT.CHQ.LIST.ERR)
    IF R.PRINT.CHQ.LIST THEN
      GOSUB UPDATE.AMOUNT.WORDS
    END
  REPEAT

  RETURN

*----------------------------------------------------------------------------
UPDATE.AMOUNT.WORDS:
*----------------------------------------------------------------------------

  CHQ.AMT.WORDS = R.PRINT.CHQ.LIST<PRINT.CHQ.LIST.AMOUNT.WORDS>
  CHQ.AMT.WORDS.LEN = LEN(CHQ.AMT.WORDS)

  CHQ.AMT.WORDS.UPDATED = ''
  BEGIN CASE
  CASE CHQ.AMT.WORDS[1,2] EQ 'UN'
    CHQ.AMT.WORDS.UPDATED = CHQ.AMT.WORDS[4,CHQ.AMT.WORDS.LEN]
  CASE CHQ.AMT.WORDS[1,5] EQ 'PESOS'
    CHQ.AMT.WORDS.UPDATED = 'CERO ':CHQ.AMT.WORDS
  END CASE

  IF CHQ.AMT.WORDS.UPDATED THEN
    R.PRINT.CHQ.LIST<PRINT.CHQ.LIST.AMOUNT.WORDS> = CHQ.AMT.WORDS.UPDATED
    CALL F.WRITE(FN.REDO.PRINT.CHQ.LIST,PRINT.CHQ.LIST.ID,R.PRINT.CHQ.LIST)
    CALL JOURNAL.UPDATE(PRINT.CHQ.LIST.ID)
  END

  RETURN

END
