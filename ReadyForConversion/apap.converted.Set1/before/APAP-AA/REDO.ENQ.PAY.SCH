*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENQ.PAY.SCH(OUT.DATA)
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Shankar Raju
*---------------------------------------------------------
* Description : This nofile rouitne is used to pass the customer value from the common variable and get the account number
*----------------------------------------------------------
* Linked With : Enquiry REDO.APAP.NATURAL.AND.LEGAL.PROSP
* In Parameter : ENQ.DATA
* Out Parameter : ENQ.DATA
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_AA.APP.COMMON

  GOSUB PROCESS

  RETURN

********
PROCESS:
*********

  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT = ''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  VAR.CUS.ID = AA$R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CUSTOMER>

  CALL F.READ(FN.CUSTOMER.ACCOUNT,VAR.CUS.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.ERR)

  CHANGE FM TO VM IN R.CUS.ACC
  OUT.DATA = R.CUS.ACC

  RETURN
END
