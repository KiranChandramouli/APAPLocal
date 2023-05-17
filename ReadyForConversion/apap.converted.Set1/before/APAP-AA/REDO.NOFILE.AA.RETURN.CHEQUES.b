*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AA.RETURN.CHEQUES(Y.FINAL.ARRAY)
*--------------------------------------------------------------
*Description: This nofile enquiry for the AA user to return the cheque.
*--------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.LOAN.FT.TT.TXN

  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*--------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------

  Y.FINAL.ARRAY = ''

  INS 'STATUS'   BEFORE D.FIELDS<1>
  INS '1'        BEFORE D.LOGICAL.OPERANDS<1>
  INS 'RETURNED' BEFORE D.RANGE.AND.VALUE<1>


  FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
  F.REDO.LOAN.FT.TT.TXN  = ''
  CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

  RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------


  CALL REDO.E.FORM.SEL.STMT(FN.REDO.LOAN.FT.TT.TXN, '', '', SEL.CMD)
  CALL EB.READLIST(SEL.CMD,IDS.LIST,'',NO.OF.REC,SEL.ERR)
  IF IDS.LIST THEN
    GOSUB FORM.ARRAY
  END
  RETURN
*--------------------------------------------------------------
FORM.ARRAY:
*--------------------------------------------------------------

  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE NO.OF.REC
    Y.ID = IDS.LIST<Y.VAR1>
    CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,Y.ID,R.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN,TXN.ERR)
    Y.FT.IDS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.FT.TRANSACTION.ID>
    IF Y.FT.IDS THEN
      GOSUB PROCESS.REMAIN
    END
    Y.VAR1++
  REPEAT
  RETURN
*--------------------------------------------------------------
PROCESS.REMAIN:
*--------------------------------------------------------------
  Y.FT.IDS.CNT = DCOUNT(Y.FT.IDS,VM)
  Y.VAR2 = 1
  LOOP
  WHILE Y.VAR2 LE Y.FT.IDS.CNT
    Y.RETURN.AMOUNT   = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,Y.VAR2>
    Y.RETURNED.AMOUNT = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.AMOUNT,Y.VAR2>
    Y.AMOUNT          = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,Y.VAR2>
    IF Y.RETURN.AMOUNT NE Y.RETURNED.AMOUNT AND Y.RETURN.AMOUNT NE '' THEN
      GOSUB FORM.ARRAY.FINAL
    END
    Y.VAR2++
  REPEAT
  RETURN
*--------------------------------------------------------------
FORM.ARRAY.FINAL:
*--------------------------------------------------------------
  Y.PROCESS.ID = ''
  Y.TXN.ID     = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.FT.TRANSACTION.ID,Y.VAR2>
  Y.REV.ID     = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.FT.REF,Y.VAR2>
  Y.LOAN.ID    = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.LOAN.ID,Y.VAR2>
  IF Y.REV.ID THEN
    Y.PROCESS.ID = Y.REV.ID
  END ELSE
    Y.PROCESS.ID = Y.TXN.ID
  END
  IF Y.PROCESS.ID THEN
    Y.FINAL.ARRAY<-1> = Y.LOAN.ID:"*":Y.AMOUNT:"*":Y.TXN.ID:"*":Y.RETURN.AMOUNT:"*":Y.PROCESS.ID
  END

  RETURN
END
