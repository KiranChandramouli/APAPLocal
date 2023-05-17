*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.CUSTOMER.NAME
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Riyas J
* Program Name  : REDO.V.ANC.CUSTOMER.NAME
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This AUTO NEW CONTENT routine attached to the version to get customer name
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 19-04-2012        Riyas           ODR-2010-01-0213  Initial creation
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.APAP.CLEARING.INWARD
$INSERT I_System
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*------------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------------------------------------------

  Y.ACCOUNT.NO = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
  CALL System.setVariable("CURRENT.ACCOUNT.NUM",Y.ACCOUNT.NO)

  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
  Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
  CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
  Y.SHORT.NAME= R.CUSTOMER<EB.CUS.SHORT.NAME>
  R.NEW(CLEAR.CHQ.REFER.NAME) = Y.SHORT.NAME
  RETURN
END
