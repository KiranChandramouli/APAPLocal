*-----------------------------------------------------------------------------
* <Rating>-36</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE REDO.EB.CHECK.CHAR

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.ASCII.VALUES
  $INSERT I_F.ASCII.VAL.TABLE
  $INSERT I_F.EB.SECURE.MESSAGE

  GOSUB INITIALISE
  GOSUB READ.ASCII.VAL.TABLE
  IF ERR.MSG THEN
    RETURN
  END
  CNT = 1
  LOOP
  WHILE CNT LE NO.CHARS
    GOSUB PROCESS.INPUT
    IF ERR.MSG THEN
      RETURN
    END
    CNT++
  REPEAT

  RETURN
***********************************************************
INITIALISE:
***********************************************************



  APP.BEN = 'EB.SECURE.MESSAGE'
  APP.FLD = 'L.ESM.MSG.REP'
  BEN.APP.POS = ''
  CALL MULTI.GET.LOC.REF(APP.BEN,APP.FLD,BEN.APP.POS)
  POS.L.ESM.MSG.REP = BEN.APP.POS<1,1>

  Y.POS.L.ESM.MSG.REP = R.NEW(EB.SM.LOCAL.REF)<1,POS.L.ESM.MSG.REP>

  ERR.MSG = ''
  NO.CHARS = LEN(Y.POS.L.ESM.MSG.REP)
  NO.RANGES = ''
  NO.SINGLE.VALUES = ''
  ERROR.MESSAGE = ''

  RETURN
***********************************************************
READ.ASCII.VAL.TABLE:
***********************************************************
  TABLE.TO.USE = 'APAP.CLAIMS'
  READ.FAILED = ''
  ASCII.VAL.TABLE.REC = ''
  CALL CACHE.READ('F.ASCII.VAL.TABLE',TABLE.TO.USE,ASCII.VAL.TABLE.REC,READ.FAILED)       ;* replaces F.READ
  IF READ.FAILED THEN
    ERR.MSG = 'ASCII.VAL.TABLE NOT SET UP FOR ':TABLE.TO.USE
  END ELSE
    IF ASCII.VAL.TABLE.REC<ASVT.START.RANGE> NE '' THEN
      NO.RANGES = DCOUNT(ASCII.VAL.TABLE.REC<ASVT.START.RANGE>,VM)
    END
    IF ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE> NE '' THEN
      NO.SINGLE.VALUES = DCOUNT(ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE>,VM)
    END
    ERROR.MESSAGE = ASCII.VAL.TABLE.REC<ASVT.ERR.MESSAGE,LNGG>
    IF ERROR.MESSAGE = '' THEN
      ERROR.MESSAGE = ASCII.VAL.TABLE.REC<ASVT.ERR.MESSAGE,1>
    END
  END

  RETURN

***********************************************************
PROCESS.INPUT:
***********************************************************

  CHAR.FOUND = ''
  CHAR.TO.CHECK = SEQX(Y.POS.L.ESM.MSG.REP[CNT,1])

  IF NO.RANGES THEN
    X = 1
    LOOP
    WHILE X LE NO.RANGES
      START.RANGE.VAL = ASCII.VAL.TABLE.REC<ASVT.START.RANGE,X>
      END.RANGE.VAL = ASCII.VAL.TABLE.REC<ASVT.END.RANGE,X>

      IF CHAR.TO.CHECK GE START.RANGE.VAL AND CHAR.TO.CHECK LE END.RANGE.VAL THEN         ;* Match found
        CHAR.FOUND = 1
        RETURN      ;* and check the next character
      END
      X++
    REPEAT
  END

  IF NO.SINGLE.VALUES THEN
    Y.ASVT.SINGLE.VALUE  = ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE>
    CHANGE VM TO FM IN Y.ASVT.SINGLE.VALUE
    LOCATE CHAR.TO.CHECK IN Y.ASVT.SINGLE.VALUE SETTING LOC.POS THEN
      CHAR.FOUND = 1
      RETURN        ;* and check the next character
    END ELSE
      LOC.POS = ' '
    END
  END

  IF CHAR.FOUND = '' THEN     ;* Set error message
    ETEXT ='EB-VERIEFY.TEXT'
    AF= ''
*    AV = POS.L.ESM.MSG.REP
    CALL STORE.END.ERROR
  END

  RETURN

***
END
