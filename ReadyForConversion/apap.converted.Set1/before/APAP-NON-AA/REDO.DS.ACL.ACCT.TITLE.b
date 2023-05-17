*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.ACL.ACCT.TITLE(ACCT.TITLE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.ACL.ACCT.TITLE
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

  FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
  F.ACCOUNT.HIS = ''
  CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

  VAR.ID = ID.NEW
  CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF NOT(R.ACCOUNT) THEN
    CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,VAR.ID,R.ACCOUNT,ACC.ERR)
  END
  ACCT.TITLE = R.ACCOUNT<AC.ACCOUNT.TITLE.1>:" ":R.ACCOUNT<AC.ACCOUNT.TITLE.2>

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
