*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DT.PYMT.INS(PYMT.INS)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.PYMT.INS
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------

*Description:  REDO.APAP.DT.PYMT.INS is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the field value from OUR.ACCOUNT.PAY and
*              if not then reads from CPARTY.CORR.NO+CPY.CORR.ADD+CPARTY.BANK.ACC
* In parameter  : None
* out parameter : PYMT.INS
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX

  GOSUB PROCESS.PARA
  RETURN

PROCESS.PARA:
  GOSUB GET.PYMT.INS
  RETURN

GET.PYMT.INS:
*Get the Payment Details

  IF R.NEW(FX.OUR.ACCOUNT.PAY) THEN
    PYMT.INS  = R.NEW(FX.OUR.ACCOUNT.PAY)
  END
  ELSE
    Y.CPARTY.NO = R.NEW(FX.CPARTY.CORR.NO)
    Y.CPY.ADD = R.NEW(FX.CPY.CORR.ADD)
    CHANGE VM TO ' ' IN Y.CPY.ADD
    CHANGE SM TO ' ' IN Y.CPY.ADD
    Y.CPY.BANK.ACC = R.NEW(FX.CPARTY.BANK.ACC)
    PYMT.INS = Y.CPARTY.NO:' ':Y.CPY.ADD:' ':Y.CPY.BANK.ACC
    RETURN
  END
END
