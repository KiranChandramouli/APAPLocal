*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.RBHP.PADRONE(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.RBHP.PADRONE
*-----------------------------------------------------------------------------
* Description :Bulit routine to assign value to set variable.
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
* 10-11-2011    ODR2011080055          Pradeep M
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT

  GOSUB OPEN.PROCESS
  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*-----------

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''

  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN

PROCESS:
*-------

  Y.ACCT.ID=ENQ.DATA<4>

  R.ACCOUNT=''
  ERR.ACCT=''
  CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
  IF R.ACCOUNT NE '' THEN

    Y.CUS.ID=R.ACCOUNT<AC.CUSTOMER>

    CALL System.setVariable("CURRENT.CUSTOMER",Y.CUS.ID)
  END

  RETURN

END
