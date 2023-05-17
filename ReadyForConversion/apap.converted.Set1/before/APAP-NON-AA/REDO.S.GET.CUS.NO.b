*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.CUS.NO(CUS.OUT)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.CUS.NO
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FT.FXSN.SLIP to retrieve CUSTOMER no from the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 30-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.FOREX.SEQ.NUM

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------

  FN.REDO.FOREX.SEQ.NUM = "F.REDO.FOREX.SEQ.NUM"
  F.REDO.FOREX.SEQ.NUM  = ""
  CALL OPF(FN.REDO.FOREX.SEQ.NUM, F.REDO.FOREX.SEQ.NUM)

  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  CONTRACT.ID = FIELD(CUS.OUT,'-',2)
  R.REDO.FOREX.SEQ.NUM = ""
  REDO.FOREX.SEQ.NUM.ERR = ""
  CALL F.READ(FN.REDO.FOREX.SEQ.NUM,CONTRACT.ID,R.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM,REDO.FOREX.SEQ.NUM.ERR)
  CUS.OUT = R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CUSTOMER.NO>

  RETURN

END
