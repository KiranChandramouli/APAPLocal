*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.UPD.REPLICA.AC.AA

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ACCOUNT
$INSERT I_F.EB.CONTRACT.BALANCES
$INSERT I_F.ACCOUNT
$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.STATIC.CHANGE.TODAY


  IF (c_aalocActivityStatus EQ 'AUTH') THEN

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.REDO.CONCAT.ACC.WOF = 'F.REDO.CONCAT.ACC.WOF'
    F.REDO.CONCAT.ACC.WOF  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    LOC.REF.APPLICATION  = "ACCOUNT":FM:"AA.PRD.DES.ACCOUNT"
    LOC.REF.FIELDS       = 'L.LOAN.STATUS':FM:'L.LOAN.STATUS'
    LOC.REF.POS          = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.LOAN.STATUS    = LOC.REF.POS<1,1>
    POS.AA.L.LOAN.STATUS = LOC.REF.POS<2,1>

    GOSUB PROCESS

  END

  GOSUB PGM.END


PROCESS:

  Y.ARR.ID  = c_aalocArrId
  IN.ACC.ID = ''
  OUT.ID = ''
  CALL  REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)

  Y.LOAN.ACC.NO = OUT.ID

  CALL F.READ(FN.REDO.CONCAT.ACC.NAB,Y.LOAN.ACC.NO,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,NAB.ERR)

  IF R.REDO.CONCAT.ACC.NAB THEN
    GOSUB UPDATE.ACCOUNT.NAB
  END

  CALL F.READ(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.ACC.NO,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,NAB.ERR)

  IF R.REDO.CONCAT.ACC.WOF THEN
    GOSUB UPDATE.ACCOUNT.WOF
  END


  RETURN

UPDATE.ACCOUNT.NAB:

  Y.WRITE.ACC = ''
  Y.LOAN.ACC.NO = R.REDO.CONCAT.ACC.NAB<1>
  CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

  R.ACCOUNT<AC.LOCAL.REF,POS.L.LOAN.STATUS> = R.NEW(AA.AC.LOCAL.REF)<1,POS.AA.L.LOAN.STATUS>

  CALL F.LIVE.WRITE(FN.ACCOUNT,Y.LOAN.ACC.NO,R.ACCOUNT)

  CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.LOAN.ACC.NO,R.ECB,F.EB.CONTRACT.BALANCES,ECB.ERR)
  IF R.ECB THEN
    R.SCT = ''
    R.SCT<RE.SCT.SYSTEM.ID>   = R.ECB<ECB.PRODUCT>
    R.SCT<RE.SCT.OLD.PRODCAT> = R.ACCOUNT<AC.CATEGORY>
    OLD.CONSOL.KEY            = R.ECB<ECB.CONSOL.KEY>
    NEW.CONSOL.KEY = ''
    CALL UPDATE.STATIC.CHANGE.TODAY(Y.LOAN.ACC.NO, OLD.CONSOL.KEY, NEW.CONSOL.KEY, R.SCT)
  END

  RETURN

UPDATE.ACCOUNT.WOF:

  Y.WRITE.ACC = ''
  Y.ACC.CNT = DCOUNT(R.REDO.CONCAT.ACC.WOF,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.ACC.CNT

    Y.LOAN.ACC.NO = R.REDO.CONCAT.ACC.WOF<Y.VAR1>
    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    R.ACCOUNT<AC.LOCAL.REF,POS.L.LOAN.STATUS> = R.NEW(AA.AC.LOCAL.REF)<1,POS.AA.L.LOAN.STATUS>

    CALL F.LIVE.WRITE(FN.ACCOUNT,Y.LOAN.ACC.NO,R.ACCOUNT)

    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.LOAN.ACC.NO,R.ECB,F.EB.CONTRACT.BALANCES,ECB.ERR)
    IF R.ECB THEN
      R.SCT = ''
      R.SCT<RE.SCT.SYSTEM.ID>   = R.ECB<ECB.PRODUCT>
      R.SCT<RE.SCT.OLD.PRODCAT> = R.ACCOUNT<AC.CATEGORY>
      OLD.CONSOL.KEY            = R.ECB<ECB.CONSOL.KEY>
      NEW.CONSOL.KEY = ''
      CALL UPDATE.STATIC.CHANGE.TODAY(Y.LOAN.ACC.NO, OLD.CONSOL.KEY, NEW.CONSOL.KEY, R.SCT)
    END
    Y.VAR1++
  REPEAT

  RETURN

PGM.END:
END
