*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PAY.AMT.SETTLE(TXN.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :H GANESH
*Program   Name    :REDO.PAY.AMT.SETTLE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the value of TXN.AMOUNT
*                   for TELLER & TELLER
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
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ARR.ACTIVITY,F.ARR.ACTIVITY)
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
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
  Y.ID=ID.NEW
  Y.SYSTEM.ID='AA'
  GOSUB SELECTION
  RETURN

*--------*
FT:
*--------*
* This gosub is for FT
  Y.ACCOUNT.ID = R.NEW(FT.CREDIT.ACCT.NO)
  VALUE.DATE=R.NEW(FT.CREDIT.VALUE.DATE)
  Y.ID=R.NEW(@ID)
  Y.SYSTEM.ID='AA'
  GOSUB SELECTION
  RETURN
*--------*
SELECTION:
*--------*
* To calculate the Payment posted to Principal Decrease

  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACC,F.ACCOUNT,ERR.ACC)
  Y.ARRANGEMENT.ID=R.ACC<AC.ARRANGEMENT.ID>
  SEL.CMD="SELECT ":FN.ARR.ACTIVITY:" WITH ACTIVITY EQ LENDING-APPLYPAYMENT-PR.PRINCIPAL.DECREASE AND EFFECTIVE.DATE EQ ":VALUE.DATE
  CALL EB.READLIST(SEL.CMD,Y.ARR.ACTIVITY.ID,'',NOF,ACCT.ERR)
  VAR1=1
  LOOP
  WHILE VAR1 LE NOF
    Y.ARR.ACT.ID=Y.ARR.ACTIVITY.ID<VAR1>
    CALL F.READ(FN.ARR.ACTIVITY,Y.ARR.ACT.ID,R.ARR.ACTIVITY,F.ARR.ACTIVITY,ACCT.ERR1)
    Y.ARRANGEMENT.ID1=R.ARR.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
    TXN.CONTRACT.ID=R.ARR.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
    ACC.MASTER=R.ARR.ACTIVITY<AA.ARR.ACT.MASTER.AAA>
    TXN.SYSTEM.ID=R.ARR.ACTIVITY<AA.ARR.ACT.TXN.SYSTEM.ID>
    IF Y.ARRANGEMENT.ID EQ Y.ARRANGEMENT.ID1 AND TXN.CONTRACT.ID EQ ACC.MASTER AND TXN.SYSTEM.ID EQ Y.SYSTEM.ID THEN
      TXN.AMT=R.ARR.ACTIVITY<AA.ARR.ACT.ORIG.TXN.AMT>
    END
    VAR1++
  REPEAT

  RETURN
END