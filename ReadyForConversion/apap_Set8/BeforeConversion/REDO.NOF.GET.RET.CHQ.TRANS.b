*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.GET.RET.CHQ.TRANS(Y.FINAL.ARRAY)
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Marimuthu S
*Program   Name    :REDO.NOF.GET.RET.CHQ.TRANS
*----------------------------------------------------------------------------------
*DESCRIPTION       : This is nofile routine will list the returned cheques
*
*---------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who             Reference            Description
* 10-SEP-2010       MARIMUTHU S       PACS00078861         Initial Creation
* 16-JAN-2012       MARIMUTHU S       PACS00170057
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.REDO.LOAN.FT.TT.TXN
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON

MAIN:

  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB PGM.END

OPENFILES:

  FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
  F.REDO.LOAN.FT.TT.TXN = ''
  CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIS = ''
  CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

PROCESS:


  LOCATE 'ARRANGEMENT.ID' IN D.FIELDS SETTING POS.AR THEN
    Y.ARR = D.RANGE.AND.VALUE<POS.AR>
    Y.SET = 'Y'
  END

  SEL.CMD = 'SELECT ':FN.REDO.LOAN.FT.TT.TXN:' WITH STATUS NE PROCESSED'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  LOOP
    REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
  WHILE Y.ID:POS.ID
    IF Y.ID[1,2] EQ 'FT' THEN
      CALL F.READ(FN.FUNDS.TRANSFER,Y.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
      IF NOT(R.FUNDS.TRANSFER) THEN
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.ID,R.FUNDS.TRANSFER,FT.HIS.ERR)
        Y.ID = FIELD(Y.ID,';',1)
      END
      Y.AC.ID = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
      CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
      Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

      CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,Y.ID,R.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN,FT.TT.ERR)
      Y.PAID.AMT = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT>
      Y.CHQ.STATUS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.STATUS>
      Y.TXNS.AMTS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.REQ.TXN.AMT>
      Y.RET.CHQS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.NO>
      Y.NEW.TXN.ID = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.NEW.TXN.ID>
      Y.VERSION = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.VERSION.NAME>
      GOSUB PROCESS.CHQ
      IF Y.SET NE 'Y' THEN
        Y.FINAL.ARRAY<-1> = Y.ARR.ID:'*':Y.PAID.AMT:'*':Y.CHK:'*':Y.TXN.AMT:'*':Y.ID:'*':Y.NEW.TXN.ID:'*':Y.VERSION
      END ELSE
        IF Y.ARR EQ Y.ARR.ID THEN
          Y.FINAL.ARRAY<-1> = Y.ARR.ID:'*':Y.PAID.AMT:'*':Y.CHK:'*':Y.TXN.AMT:'*':Y.ID:'*':Y.NEW.TXN.ID:'*':Y.VERSION
        END
      END
    END
  REPEAT

  RETURN

PROCESS.CHQ:

  Y.CHK = ''; Y.TXN.AMT = ''
  Y.CNT.CHQ = DCOUNT(Y.RET.CHQS,VM)
  FLG = ''
  LOOP
  WHILE Y.CNT.CHQ GT 0 DO
    FLG += 1
    Y.STAT = Y.CHQ.STATUS<1,FLG>
    IF Y.STAT EQ 'RETURN' THEN
      IF Y.CHK EQ '' THEN
        Y.CHK = Y.RET.CHQS<1,FLG>
        Y.TXN.AMT = Y.TXNS.AMTS<1,FLG>
      END ELSE
        Y.CHK := VM:Y.RET.CHQS<1,FLG>
        Y.TXN.AMT := VM:Y.TXNS.AMTS<1,FLG>
      END
    END
    Y.CNT.CHQ -= 1
  REPEAT

  RETURN

PGM.END:

END
