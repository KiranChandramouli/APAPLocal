*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.ACC2.ALT.ACCT.ID(Y.ACCT.TITLE)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*-------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT

  GOSUB PROCESS

  RETURN
*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------
  GET.ACCT.TITLE = R.NEW(TT.TE.ACCOUNT.2)
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
  Y.ACCT.TITLE = R.ACCOUNT<AC.ALT.ACCT.ID>
  Y.ACCT.TITLE=CHANGE(Y.ACCT.TITLE,SM,VM)
  Y.ACCT.TITLE=CHANGE(Y.ACCT.TITLE,FM,VM)
  Y.ACCT.TITLE = Y.ACCT.TITLE<1,1>
  Y.ACCT.TITLE = FMT(Y.ACCT.TITLE,"R#20")


  RETURN

END
