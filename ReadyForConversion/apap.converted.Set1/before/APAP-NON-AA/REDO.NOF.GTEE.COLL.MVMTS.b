*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.GTEE.COLL.MVMTS(FIN.ARR)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.COLLATERAL
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.ACTIVITY.HISTORY
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
* PACS00313081 - 2015APR29 - Sandra's email - S
$INSERT I_F.ALTERNATE.ACCOUNT
$INSERT I_F.AA.ACCOUNT
* PACS00313081 - 2015APR29 - Sandra's email - E
  FN.COL = 'F.COLLATERAL'
  F.COL = ''
  CALL OPF(FN.COL,F.COL)

  FN.AA = 'F.AA.ARRANGEMENT'
  F.AA = ''
  CALL OPF(FN.AA,F.AA)

  FN.AA.HIS = 'F.AA.ACTIVITY.HISTORY'
  F.AA.HIS = ''
  CALL OPF(FN.AA.HIS,F.AA.HIS)

  FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
  F.AAA = ''
  CALL OPF(FN.AAA,F.AAA)
* PACS00313081 - 2015APR29 - Sandra's email - S
  FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
  F.ALTERNATE.ACCOUNT = ''
* PACS00313081 - 2015APR29 - Sandra's email - E
  Y.AAPL = 'COLLATERAL'
  Y.FLDS = 'L.CO.DOCS.POL':VM:'L.AC.LK.COL.ID':VM:'L.CO.MVMT.TYPE':VM:'L.CO.REASN.MVMT':VM:'L.CO.LOAN.STAT':VM:'L.CO.SRECP.DATE':VM:'L.CO.DATE.MVMT':VM:'L.CO.RES.MVMT':VM:'L.CO.REG.DATE':VM:'L.CO.CR.DATE'
  CALL MULTI.GET.LOC.REF(Y.AAPL,Y.FLDS,POS.L)
  Y.DOCS.POS = POS.L<1,1>
  Y.LCK.POS = POS.L<1,2>
  Y.MVT.POS = POS.L<1,3>
  Y.RSN.POS = POS.L<1,4>
  Y.LN.POS = POS.L<1,5>
  Y.SCRP.POS = POS.L<1,6>
  Y.COM.POS = POS.L<1,7>
  Y.RES.POS = POS.L<1,8>
  Y.REG.POS = POS.L<1,9>
  Y.CR.POS = POS.L<1,10>

  SEL.CMD = 'SELECT ':FN.COL:' WITH L.AC.LK.COL.ID LIKE AA...'

  GOSUB SEL.CRT
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ER)
  FLG = ''
  LOOP
  WHILE NO.OF.REC GT 0 DO
    FLG += 1
    GOSUB PROCESS
    NO.OF.REC -= 1
  REPEAT

  RETURN

SEL.CRT:

  LOCATE 'COLLATERAL.CODE' IN D.FIELDS SETTING POS.C THEN
    Y.CC.VAL = D.RANGE.AND.VALUE<POS.C>
    SEL.CMD := ' AND COLLATERAL.CODE EQ ':Y.CC.VAL
  END
  LOCATE 'L.CO.DATE.MVMT' IN D.FIELDS SETTING POS.CD THEN
    Y.CO.D.M = D.RANGE.AND.VALUE<POS.CD>
    SEL.CMD := ' AND L.CO.DATE.MVMT LE ':Y.CO.D.M
  END
  LOCATE 'L.CO.MVMT.TYPE' IN D.FIELDS SETTING PS.MVT THEN
    Y.CO.MV.TY = D.RANGE.AND.VALUE<PS.MVT>
    SEL.CMD := ' AND L.CO.MVMT.TYPE EQ ':Y.CO.MV.TY
  END
  LOCATE 'L.CO.REASN.MVMT' IN D.FIELDS SETTING POS.RSN THEN
    Y.RSN.MVT = D.RANGE.AND.VALUE<POS.RSN>
    SEL.CMD := ' AND L.CO.REASN.MVMT EQ ':Y.RSN.MVT
  END
  LOCATE 'L.CO.LOC.STATUS' IN D.FIELDS SETTING POS.ST THEN
    Y.LC.STATS = D.RANGE.AND.VALUE<POS.ST>
    SEL.CMD := ' AND L.CO.LOC.STATUS EQ ':Y.LC.STATS
  END
  LOCATE 'L.CO.RES.MVMT' IN D.FIELDS SETTING POS.RS.MV THEN
    Y.RS.MCSF = D.RANGE.AND.VALUE<POS.RS.MV>
    SEL.CMD := ' AND L.CO.RES.MVMT EQ ':Y.RS.MCSF
  END

  RETURN

PROCESS:

  Y.CO.ID = SEL.LIST<FLG>
  CALL F.READ(FN.COL,Y.CO.ID,R.COL,F.COL,COL.ERR)
  Y.CO.CODE = R.COL<COLL.COLLATERAL.CODE>
  Y.COMN = Y.CO.CODE:'-':Y.CO.ID
  Y.DOC.POL = R.COL<COLL.LOCAL.REF,Y.DOCS.POS>
  Y.AA.ID = R.COL<COLL.LOCAL.REF,Y.LCK.POS>
  CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,AA.ER)
  IF R.AA THEN

    GOSUB GET.ALT.ACCT        ;* PACS00313081 - 2015APR29 - Sandra's email - S/E

    IF R.AA<AA.ARR.ARR.STATUS> NE 'AUTH' AND R.AA<AA.ARR.ARR.STATUS> NE 'UNAUTH' THEN
      Y.AC.ID = R.AA<AA.ARR.LINKED.APPL.ID>

      Y.MVMT.TYPE = R.COL<COLL.LOCAL.REF,Y.MVT.POS>
      Y.RSN.MVMT = R.COL<COLL.LOCAL.REF,Y.RSN.POS>
      Y.LON.STAT = R.COL<COLL.LOCAL.REF,Y.LN.POS>
      Y.SCRP.DATE = R.COL<COLL.LOCAL.REF,Y.SCRP.POS>
      Y.CO.MVM.DATE = R.COL<COLL.LOCAL.REF,Y.COM.POS>
      Y.RES.PER = R.COL<COLL.LOCAL.REF,Y.RES.POS>
      Y.REG.DATE = R.COL<COLL.LOCAL.REF,Y.REG.POS>
      Y.CR.DATE = R.COL<COLL.LOCAL.REF,Y.CR.POS>
      Y.PRD = R.AA<AA.ARR.PRODUCT>

      GOSUB GET.DISB.DETAILS

      GOSUB GET.OS.AMT
* PACS00313081 - 2015APR29 - Sandra's email - S
*            FIN.ARR<-1> = Y.CO.CODE:'*':Y.CO.ID:'*':Y.COMN:'*':Y.DOC.POL:'*':Y.AC.ID:'*':Y.AA.ID:'*':Y.MVMT.TYPE:'*':Y.RSN.MVMT:'*':Y.LON.STAT:'*':Y.SCRP.DATE:'*':Y.CO.MVM.DATE:'*':Y.RES.PER:'*':Y.REG.DATE:'*':Y.CR.DATE:'*':Y.DESB.DD:'*':Y.TOT.DIS.AMT:'*':Y.PRD:'*':Y.PRIN.BAL
      FIN.ARR<-1> = Y.CO.CODE:'*':Y.CO.ID:'*':Y.COMN:'*':Y.DOC.POL:'*':Y.AC.ID:'*':Y.ACC.NUMBER:'*':Y.MVMT.TYPE:'*':Y.RSN.MVMT:'*':Y.LON.STAT:'*':Y.SCRP.DATE:'*':Y.CO.MVM.DATE:'*':Y.RES.PER:'*':Y.REG.DATE:'*':Y.CR.DATE:'*':Y.DESB.DD:'*':Y.TOT.DIS.AMT:'*':Y.PRD:'*':Y.PRIN.BAL
* PACS00313081 - 2015APR29 - Sandra's email - E
    END
  END

  RETURN

GET.ALT.ACCT:

  Y.ACC.NUMBER = '' ; R.ALTERNATE.ACCOUNT = "" ; Y.ERR = ''
  CALL F.READ(FN.ALTERNATE.ACCOUNT, Y.AA.ID, R.ALTERNATE.ACCOUNT, F.ALTERNATE.ACCOUNT, Y.ERR)
  Y.ACC.NUMBER = R.ALTERNATE.ACCOUNT

  RETURN

GET.OS.AMT:

  Y.OVR.ST = 'CUR':VM:'DUE':VM:'DE1':VM:'DE3':VM:'DEL':VM:'NAB'
  REQUEST.TYPE<2> = 'ALL';REQUEST.TYPE<4> = 'ECB'

  FLG.P = ''
  Y.CNT.L = DCOUNT(Y.OVR.ST,VM) ; Y.PRIN.BAL = '' ; Y.IN.BAL = ''; REQUEST.DATE = TODAY ;
  LOOP
  WHILE Y.CNT.L GT 0 DO
    FLG.P += 1
    Y.PRO = Y.OVR.ST<1,FLG.P>:'ACCOUNT'

    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.AC.ID, Y.PRO, REQUEST.DATE, BALANCE.AMOUNT,RET.ERROR)
    Y.PRIN.BAL += ABS(BALANCE.AMOUNT)

    Y.CNT.L -= 1
  REPEAT

  RETURN

GET.DISB.DETAILS:

  CALL F.READ(FN.AA.HIS,Y.AA.ID,R.AA.HIS,F.AA.HIS,HIS.ERR)
  Y.ACTY = R.AA.HIS<AA.AH.ACTIVITY> ; Y.ACTY = CHANGE(Y.ACTY,SM,VM) ; Y.ACTY.DUP = Y.ACTY
  Y.ACTY.REF = R.AA.HIS<AA.AH.ACTIVITY.REF> ; Y.ACTY.REF = CHANGE(Y.ACTY.REF,SM,VM); Y.ACTY.REF.DUP = Y.ACTY.REF
  Y.ACT.STS = R.AA.HIS<AA.AH.ACT.STATUS> ; Y.ACT.STS = CHANGE(Y.ACT.STS,SM,VM) ; Y.ACT.STS.DUP = Y.ACT.STS
* PACS00313081 - 2015APR29 - Sandra's email - S
  CALL REDO.GET.DISBURSEMENT.DETAILS(Y.AA.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
  Y.DESB.DD = R.DISB.DETAILS<1,1>       ;* Disbursement Date.
  Y.TOT.DIS.AMT = R.DISB.DETAILS<3>     ;* Total Disb amount.
* PACS00313081 - 2015APR29 - Sandra's email - E
  RETURN

END
