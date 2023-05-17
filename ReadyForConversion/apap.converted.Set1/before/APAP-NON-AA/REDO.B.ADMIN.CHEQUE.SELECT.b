*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.ADMIN.CHEQUE.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.UPDATE.DETAILS.ACH.SELECT
* ODR NUMBER    : ODR-2009-10-0795
*-------------------------------------------------------------------------------------------------
* Description   : This is .select routine will fetch the STMT.ENTRY details and pass the values to main routine
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s    ODR-2009-10-0795  Initial Creation
*-------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PAY.MODE.PARAM
$INSERT I_ENQUIRY.COMMON
$INSERT I_REDO.B.ADMIN.CHEQUE.COMMON
$INSERT I_F.DATES
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
  CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,'SYSTEM',R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)
  Y.PAYMNT.MODE = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>
  LOCATE 'Admin.check' IN Y.PAYMNT.MODE<1,1> SETTING POS THEN
    Y.ACCT.NO = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
  END
  IF Y.ACCT.NO THEN
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
      Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
      D.FIELDS = 'ACCOUNT':FM:'BOOKING.DATE'
      D.LOGICAL.OPERANDS = 1:FM:4
      D.RANGE.AND.VALUE = Y.ACCT.NO:FM:Y.LAST.DAY
      Y.VALUE.LIST = ''
      CALL E.STMT.ENQ.BY.CONCAT(Y.VALUE.LIST)
      CALL BATCH.BUILD.LIST('',Y.VALUE.LIST)
    END
  END

  RETURN
*-----------------------------------------------------------------------------
END
