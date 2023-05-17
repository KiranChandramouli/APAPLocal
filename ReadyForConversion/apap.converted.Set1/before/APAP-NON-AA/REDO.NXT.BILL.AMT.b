*-----------------------------------------------------------------------------
* <Rating>-73</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NXT.BILL.AMT(TXN.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :H GANESH
*Program   Name    :REDO.NXT.BILL.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the value of TXN.AMOUNT
*                   for TELLER & FT
*
*LINKED WITH       : TT.OVER.PYMNT  & FT.OVER.PYMNT
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*20.12.2009      H GANESH            ODR-2009-10-0305  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.ACCOUNT


  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*-------------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------------
  FN.ARR.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY$NAU'
  F.ARR.ACTIVITY=''
  CALL OPF(FN.ARR.ACTIVITY,F.ARR.ACTIVITY)
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
  LOC.APPLICATION='TELLER':FM:'FUNDS.TRANSFER'
  LOC.FIELDS='L.TT.NEXT.PAY':FM:'L.FT.NEXT.PAY'
  LOC.POS=''
  CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)

  L.TT.NEXT.PAY.POS=LOC.POS<1,1>
  L.FT.NEXT.PAY.POS=LOC.POS<2,1>

  IF APPLICATION EQ 'TELLER' THEN
    GOSUB TELLER
  END
  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    GOSUB FT
  END
  RETURN
*--------*
TELLER:
*--------*
* This gosub is for TELLER
  Y.ACCOUNT.ID = R.NEW(TT.TE.ACCOUNT.2)
  VALUE.DATE=R.NEW(TT.TE.VALUE.DATE.2)
  TOTAL.DUE.AMT=R.NEW(TT.TE.LOCAL.REF)<1,L.TT.NEXT.PAY.POS>
  Y.ID=ID.NEW
  GOSUB SELECTION
  RETURN
*--------*
FT:
*--------*
* This gosub is for FT
  Y.ACCOUNT.ID = R.NEW(FT.CREDIT.ACCT.NO)
  VALUE.DATE=R.NEW(FT.CREDIT.VALUE.DATE)
  TOTAL.DUE.AMT=R.NEW(FT.LOCAL.REF)<1,L.FT.NEXT.PAY.POS>
  Y.ID=ID.NEW
  GOSUB SELECTION
  RETURN
*--------*
SELECTION:
*--------*
* To calculate the Payment posted to next bill amount
  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACC,F.ACCOUNT,ERR.ACC)
  Y.ARRANGEMENT.ID=R.ACC<AC.ARRANGEMENT.ID>
  SEL.CMD="SELECT ":FN.ARR.ACTIVITY:" WITH ACTIVITY EQ LENDING-APPLYPAYMENT-PR.REGBILLOVERPAYMENT AND EFFECTIVE.DATE EQ ":VALUE.DATE: " AND TXN.CONTRACT.ID EQ ":Y.ID
  CALL EB.READLIST(SEL.CMD,Y.ARR.ACTIVITY.ID,'',NOF,ACCT.ERR)
  VAR1=1
  LOOP
  WHILE VAR1 LE NOF
    CALL F.READ(FN.ARR.ACTIVITY,Y.ARR.ACTIVITY.ID<VAR1>,R.ARR.ACTIVITY,F.ARR.ACTIVITY,ACCT.ERR1)
    Y.ARRANGEMENT.ID1=R.ARR.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
    IF Y.ARRANGEMENT.ID EQ Y.ARRANGEMENT.ID1 THEN
      ORIG.TXN.AMT=R.ARR.ACTIVITY<AA.ARR.ACT.ORIG.TXN.AMT>
      IF ORIG.TXN.AMT GT TOTAL.DUE.AMT THEN
        TXN.AMT=ORIG.TXN.AMT
      END  ELSE
        TXN.AMT=TOTAL.DUE.AMT
      END
    END
    VAR1=VAR1+1
  REPEAT
  RETURN
END
