*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.ACL.SET.ACCT.TITLE(ACCT.TITLE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.ACL.SET.ACCT.TITLE
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the account title value.
* ----------------------------------------------------------------------------------
* MODIFICATION HISTORY:
* DATE            WHO               REFERENCE              DESCRIPTION
* 07 MAY 2012     Sudharsanan S     CR.20         This program is used to get the account title value.
*------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_F.ACCOUNT

  GOSUB PROCESS
  RETURN
*********
PROCESS:
**********
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  VAR.ID = R.NEW(AC.ACL.SETTLEMENT.ACCT)

  CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  ACCT.TITLE = R.ACCOUNT<AC.ACCOUNT.TITLE.1>

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
