*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUST.TELPHONE(PHONE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.CUST.TELPHONE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Telephone number
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.CLEARING.OUTWARD

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:
*Opening Files

  FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
  F.REDO.CLEARING.OUTWARD = ''
  CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN

PROCESS:
*Getting the Description of the Reject Code

  LOC.POS = ''
  CALL MULTI.GET.LOC.REF('CUSTOMER','L.CU.TEL.NO.1',LOC.POS)

  VAR.PAYMENT.DETAILS = R.NEW(FT.PAYMENT.DETAILS)
  CALL F.READ(FN.REDO.CLEARING.OUTWARD,VAR.PAYMENT.DETAILS,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,OUTWARD.ERR)
  VAR.ACCT.ID = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.ACCOUNT>
  CALL F.READ(FN.ACCOUNT,VAR.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
  CUST.NO = R.ACCOUNT<AC.CUSTOMER>
  CALL F.READ(FN.CUSTOMER,CUST.NO,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
  PHONE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.POS>

  RETURN
END
