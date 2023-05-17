*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.CUST.NAM(CUSTOMER.NAME)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.CUS.NAME
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FX.FXSN.PSLIP, TT.FXSN.PSLIP & FT.FXSN.SLIP to retrieve CUSTOMER name from the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 13-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER

  GOSUB OPEN.FILES

  GOSUB PROCESS

  RETURN


OPEN.FILES:
*----------------------------------------------------------------------------------

  RETURN

PROCESS:
*----------------------------------------------------------------------------------
  Y.ACC.NO = R.NEW(FT.DEBIT.CUSTOMER)

  CALL REDO.CUST.IDENTITY.REF(Y.ACC.NO, Y.ALT.ID, Y.CUS.NAME)
  CUSTOMER.NAME = Y.CUS.NAME

  RETURN

END
