*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.LN.ANTER

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON


  Y.AA.IDS = O.DATA

  FN.AC = 'F.ACCOUNT'
  F.AC = ''
  CALL OPF(FN.AC,F.AC)

  FN.AA = 'F.AA.ARRANGEMENT'
  F.AA = ''
  CALL OPF(FN.AA,F.AA)


  Y.AA.IDS = CHANGE(Y.AA.IDS,SM,VM)


  Y.CNT = DCOUNT(Y.AA.IDS,VM)
  FLG = '' ; Y.PREV.LN.NUM = ''
  LOOP
  WHILE Y.CNT GT 0 DO
    FLG += 1
    Y.ID = Y.AA.IDS<1,FLG>
    CALL F.READ(FN.AA,Y.ID,R.AA,F.AA,AA.ERR)
    Y.AC.ID = R.AA<AA.ARR.LINKED.APPL.ID>
    CALL F.READ(FN.AC,Y.AC.ID,R.AC,F.AC,AC.ERR)
    Y.PREV.LN.NUM<1,-1> = R.AC<AC.ALT.ACCT.ID>
    Y.CNT -= 1
  REPEAT

  O.DATA = Y.PREV.LN.NUM

  RETURN

END
