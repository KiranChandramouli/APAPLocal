*-----------------------------------------------------------------------------
* <Rating>-83</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.TFS.PROCESS.SMB
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.INP.TFS.PROCESS
* ODR NO      : ODR-2009-10-0315
*----------------------------------------------------------------------
*DESCRIPTION: This Input routine will calculate the sum of all the payments
* in multi-value field L.AZ.AMOUNT and compare it with the PRINCIPAL. If there
* is any difference then throws the error message with the difference

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AZ.ACCOUNT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*13.05.2010  H GANESH     ODR-2009-12-0275  INITIAL CREATION
*08.11.2011  S SUDHARSANAN     CR.18        Modify
*09.12.2011  S SUDHARSANAN    PACS00146871  Modify
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.TFS.PROCESS

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB LOCAL.REF
  GOSUB PROCESS
  GOSUB END1
  RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  R.REDO.TFS.PROCESS=''
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''

  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
  LOC.REF.APPLICATION="AZ.ACCOUNT"
  LOC.REF.FIELDS='L.AZ.METHOD.PAY':VM:'L.AZ.AMOUNT':VM:'L.AZ.DEBIT.ACC':VM:'L.TYPE.INT.PAY':VM:'ORIG.LCY.AMT'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AZ.METHOD.PAY=LOC.REF.POS<1,1>
  POS.L.AZ.AMOUNT=LOC.REF.POS<1,2>
  POS.L.AZ.DEBIT.ACC=LOC.REF.POS<1,3>
  POS.L.TYPE.INT.PAY=LOC.REF.POS<1,4>
  POS.ORIG.LCY.AMT = LOC.REF.POS<1,5>
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*******CR.18-S********
  Y.CURR.NO = R.OLD(AZ.CURR.NO)
  Y.REPAY.ACCOUNT = R.NEW(AZ.REPAY.ACCOUNT)
  Y.L.AZ.DEBIT.ACC = ''
  Y.L.AZ.DEBIT.ACC = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.DEBIT.ACC>
  Y.L.AZ.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT>

*PACS00146871 - S
  IF Y.REPAY.ACCOUNT NE '' AND R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,1> AND POS.L.TYPE.INT.PAY NE 'Reinvested' THEN
    AF = AZ.REPAY.ACCOUNT
    ETEXT='EB-REDO.REINV.PAY'
    CALL STORE.END.ERROR
    GOSUB END1
  END

  Y.AZ.METHOD.PAY=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY>

  CHANGE VM TO FM IN Y.AZ.METHOD.PAY
  CHANGE SM TO FM IN Y.AZ.METHOD.PAY

  LOCATE "FROM.DISBURSEMENT" IN Y.AZ.METHOD.PAY SETTING POS.METHOD THEN
    GOSUB END1
  END

  IF NOT(Y.CURR.NO) AND NOT(Y.REPAY.ACCOUNT) THEN
    Y.VAR = '' ; DEB.CNT = 1
    DEB.ACC.CNT = DCOUNT(Y.L.AZ.DEBIT.ACC,SM)
    CHANGE SM TO FM IN Y.L.AZ.DEBIT.ACC
    LOOP
    WHILE DEB.CNT LE DEB.ACC.CNT
      Y.VAL = Y.L.AZ.DEBIT.ACC<DEB.CNT>
      IF NOT(Y.VAL) THEN
        Y.VAR = 1
        DEB.CNT = DEB.ACC.CNT
      END
      DEB.CNT++
    REPEAT
    IF (Y.VAR EQ 1) OR NOT(DEB.ACC.CNT) THEN
      GOSUB UPDATE.TFS        ;****The process is generated only on initial deposit create version for the above condition
    END
*PACS00146871 - E
  END
********CR.18-E********

  RETURN
*----------------------------------------------------------------------
UPDATE.TFS:
*----------------------------------------------------------------------
  Y.AMT = ''
  VAR.ID.NEW = ID.NEW
  R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>=VAR.ID.NEW
  R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.CUSTOMER>= R.NEW(AZ.CUSTOMER)
  CALL  F.READ(FN.ACCOUNT,VAR.ID.NEW,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT.NAME>=R.ACCOUNT<AC.MNEMONIC>
  Y.AZ.METHOS.PAY=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY>
  Y.COUNT=DCOUNT(Y.AZ.METHOS.PAY,SM)
  VAR1=1
  LOOP

  WHILE VAR1 LE Y.COUNT
    R.REDO.TFS.PROCESS<TFS.PRO.CURRENCY,VAR1>=R.NEW(AZ.CURRENCY)
    R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,VAR1> = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,VAR1>
    IF R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,VAR1> EQ 'FROM.CUST.ACC' OR R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,VAR1> EQ 'FROM.INT.ACC' OR R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,VAR1> EQ 'FROM.NOST.ACC' THEN
      R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,VAR1> = 'FROM'
    END
    IF R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY,VAR1> EQ 'CHEQUE.DEPOSIT' THEN
      R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,VAR1> =  'CHQDEP'
    END

    R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT,VAR1>=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.DEBIT.ACC,VAR1>
    R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT,VAR1>=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT,VAR1>

    Y.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT,VAR1>
    R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT,VAR1>=Y.AMOUNT
    Y.AMT +=Y.AMOUNT
    VAR1++
  REPEAT
  R.REDO.TFS.PROCESS<TFS.PRO.TOTAL.AMOUNT> = Y.AMT
  GOSUB OFS.TFS
  RETURN

*----------------------------------------------------------------------
OFS.TFS:
*----------------------------------------------------------------------

  OFS.SOURCE.ID = 'REDO.OFS.AZ.UPDATE'
  APPLICATION.NAME = 'REDO.TFS.PROCESS'
  TRANS.FUNC.VAL = 'I'
  TRANS.OPER.VAL = 'PROCESS'
  APPLICATION.NAME.VERSION = 'REDO.TFS.PROCESS,OFS.PROCESS'
  NO.AUT = '0'
  OFS.MSG.ID = ''
  APPLICATION.ID= ''
  OFS.POST.MSG = ''
  CALL OFS.BUILD.RECORD (APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT, APPLICATION.ID,R.REDO.TFS.PROCESS,OFS.REQ.MSG)
  CALL OFS.POST.MESSAGE (OFS.REQ.MSG, OFS.MSG.ID, OFS.SOURCE.ID, OFS.ERR)

  RETURN
*--------------------------------------------------------------------------
END1:
*--------------------------------------------------------------------------
END
