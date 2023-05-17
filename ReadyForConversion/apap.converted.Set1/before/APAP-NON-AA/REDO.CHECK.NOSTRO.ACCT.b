*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHECK.NOSTRO.ACCT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.CHECK.NOSTRO.ACCT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Bank name
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:
*Opening Files

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

PROCESS:
*Getting the Description of the Reject Code

  ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
  CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
  VAR.CATEG = R.ACCOUNT<AC.CATEGORY>

  IF VAR.CATEG GE 5000 AND VAR.CATEG LE 5999 THEN
    FLAG = 1
  END
  IF FLAG NE 1 THEN
    AF = FT.CREDIT.ACCT.NO
    ETEXT = "EB-INVALID.ACCT"
    CALL STORE.END.ERROR
  END
  RETURN
END
