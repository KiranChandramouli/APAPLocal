*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  PROGRAM REDO.RBHP.UTIL.RTN

$INSERT I_COMMON
$INSERT I_EQUATE

  FN.REDO.ACCT.EXCE.RBHP = 'F.REDO.ACCT.EXCE.RBHP'
  F.REDO.ACCT.EXCE.RBHP = ''
  CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

  SEL.RBHP = 'SELECT ':FN.REDO.ACCT.EXCE.RBHP
  CALL EB.READLIST(SEL.RBHP,LIST.RBHP,'',NO.OF.REC,'')

  LOOP
    REMOVE RBHP.ID FROM LIST.RBHP SETTING RBHP.POS
  WHILE RBHP.ID:RBHP.POS

    Y.APPLICATION = FIELD(RBHP.ID,'-',1)
    IF Y.APPLICATION NE 'TELLER' AND Y.APPLICATION NE 'FUNDS.TRANSFER' AND Y.APPLICATION NE 'T24.FUND.SERVICES' THEN

      FN.APPL = 'F.':Y.APPLICATION:'$NAU'
      F.APPL = ''
      CALL OPF(FN.APPL,F.APPL)
      Y.COMPANY = FIELD(RBHP.ID,'-',2)
      CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,RBHP.ID,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,RBHP.ERR)
      GOSUB CHECK.NAU.RECORD
    END
*    DELETE F.REDO.ACCT.EXCE.RBHP, RBHP.ID ;*Tus Start 
CALL F.DELETE(FN.REDO.ACCT.EXCE.RBHP,RBHP.ID) ; * Tus End
  REPEAT
  CALL JOURNAL.UPDATE('')
  RETURN

*---------------*
CHECK.NAU.RECORD:
*---------------*

  LOOP
    REMOVE REC.ID FROM R.REDO.ACCT.EXCE.RBHP SETTING REC.POS
  WHILE REC.ID:REC.POS
    CALL F.READ(FN.APPL,REC.ID,R.RECORD,F.APPL,ERR.APPL)
    IF R.RECORD THEN

      Y.REC.ID = Y.APPLICATION:'-':Y.COMPANY:'-':REC.ID
*      WRITE REC.ID ON F.REDO.ACCT.EXCE.RBHP, Y.REC.ID ;*Tus Start 
CALL F.WRITE(FN.REDO.ACCT.EXCE.RBHP,Y.REC.ID,REC.ID) ; * Tus End
    END
  REPEAT
    CALL JOURNAL.UPDATE('')
  RETURN
