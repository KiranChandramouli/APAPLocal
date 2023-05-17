*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CK.PO.NORMAL.REP

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.AA.REFERENCE.DETAILS
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.REDO.APAP.PROPERTY.PARAM
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.FUNDS.TRANSFER

  FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
  F.AA.AC = ''
  CALL OPF(FN.AA.AC,F.AA.AC)

  FN.FT = 'F.FUNDS.TRANSFER'
  F.FT = ''
  CALL OPF(FN.FT,F.FT)

  FN.AA.REF = 'F.AA.REFERENCE.DETAILS'
  F.AA.REF = ''
  CALL OPF(FN.AA.REF,F.AA.REF)

  FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
  F.AAA = ''
  CALL OPF(FN.AAA,F.AAA)

  FN.AAA.NAU = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
  F.AAA.NAU = ''
  CALL OPF(FN.AAA.NAU,F.AAA.NAU)

  FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
  F.REDO.APAP.PROPERTY.PARAM = ''
  CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

  FN.AA = 'F.AA.ARRANGEMENT'
  F.AA = ''
  CALL OPF(FN.AA,F.AA)

  FN.AC = 'F.ACCOUNT'
  F.AC = ''
  CALL OPF(FN.AC,F.AC)


  Y.AA.ID = COMI
  IF Y.AA.ID[1,2] NE 'AA' THEN
    CALL F.READ(FN.AC,Y.AA.ID,R.AC,F.AC,AC.ERR)
    Y.AA.ID = R.AC<AC.ARRANGEMENT.ID>
  END

  CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,AA.ERR)
  Y.PRD = R.AA<AA.ARR.PRODUCT.GROUP>

  CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRD,R.PARAM,F.REDO.APAP.PROPERTY.PARAM,PAR.ERR)
  Y.PAYOFF.ACT = R.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>

  CALL F.READ(FN.AA.AC,Y.AA.ID,R.AA.AC,F.AA.AC,AA.AC.ERR)

  Y.PAY.MET = R.AA.AC<AA.AD.PAY.METHOD>
  Y.PAY.MET = CHANGE(Y.PAY.MET,SM,VM)

  LOCATE 'INFO' IN Y.PAY.MET<1,1> SETTING POS.INF THEN
    Y.VAL = 'PAYOFF'
  END ELSE
    Y.VAL = 'NO'
  END

  Y.FIN = ''
  IF Y.VAL EQ 'PAYOFF' THEN
    CALL F.READ(FN.AA.REF,Y.AA.ID,R.AA.REF,F.AA.REF,REF.AA.ER)
    Y.AAA.ID = R.AA.REF<AA.REF.AAA.ID>
    Y.CNT = DCOUNT(Y.AAA.ID,VM) ; FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
      FLG += 1
      Y.AAA = Y.AAA.ID<1,FLG>
      CALL F.READ(FN.AAA,Y.AAA,R.AAA,F.AAA,AAA.ERR)
      IF NOT(R.AAA) THEN
        CALL F.READ(FN.AAA.NAU,Y.AAA,R.AAA,F.AAA.NAU,AA.ERR.N)
      END
      Y.ACT.ID = R.AAA<AA.ARR.ACT.ACTIVITY>
      GOSUB LOC.COMM
      Y.CNT -= 1
    REPEAT
  END

  IF Y.VAL EQ 'PAYOFF' AND Y.FIN EQ 'YES' THEN
    ETEXT = 'EB-PAYOFF.NOT.ALLOW.NR'
    AF = FT.CREDIT.ACCT.NO
    CALL STORE.END.ERROR
  END

  RETURN

LOC.COMM:

  LOCATE Y.ACT.ID IN Y.PAYOFF.ACT<1,1> SETTING STR.P THEN
    Y.FT.ID = R.AA.REF<AA.REF.TRANS.REF,FLG>
    CALL F.READ(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
    IF R.FT<FT.CREDIT.THEIR.REF>[1,2] NE 'FT' THEN
      Y.FIN = 'YES'
      Y.CNT = 0
    END
  END

  RETURN

END
