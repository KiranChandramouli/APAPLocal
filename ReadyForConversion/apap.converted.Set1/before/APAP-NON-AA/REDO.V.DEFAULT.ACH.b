*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.DEFAULT.ACH
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.V.DEFAULT.ACH
* ODR NUMBER    : ODR-2009-10-0795
*---------------------------------------------------------------------------------------------------
* Description   : This routine will be attached to FT version to default the credit and debit ac nos
* In parameter  : none
* out parameter : none
*---------------------------------------------------------------------------------------------------
* Modification History :
*---------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PAY.MODE.PARAM
$INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
  FN.REDO.H.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
  F.REDO.H.PAY.MODE.PARAM = ''

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,'SYSTEM',R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)
  Y.PAYMNT.MODE = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>
  Y.PAYMNT.MODE = CHANGE(Y.PAYMNT.MODE,VM,FM)
  LOCATE 'Transfer.via.ACH' IN Y.PAYMNT.MODE SETTING POS THEN
    Y.DEB.ACCT.NO = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
  END

  R.NEW(FT.DEBIT.ACCT.NO) = Y.DEB.ACCT.NO

  RETURN
*-----------------------------------------------------------------------------
END
