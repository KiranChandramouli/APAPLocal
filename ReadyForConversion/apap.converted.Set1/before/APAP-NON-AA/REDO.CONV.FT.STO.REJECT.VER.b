*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.FT.STO.REJECT.VER
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the reverse versions
*-------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.AI.REDO.PRINT.TXN.PARAM
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.STANDING.ORDER

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

***********
OPEN.FILES:
***********

  FN.AI.REDO.PRINT.TXN.PARAM = 'F.AI.REDO.PRINT.TXN.PARAM'
  F.AI.REDO.PRINT.TXN.PARAM = ''
  CALL OPF(FN.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
  F.FUNDS.TRANSFER  = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.STANDING.ORDER = 'F.STANDING.ORDER$NAU'
  F.STANDING.ORDER  =  ''
  CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)
  RETURN
**********
PROCESS:
*********

  Y.TXN.ID = O.DATA
  IF Y.TXN.ID[1,2] EQ 'FT' THEN
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    Y.TXN.CODE  = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
    Y.FT.REJ.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.FT.REJECT.VERSION>
    O.DATA = 'COS ':Y.FT.REJ.COS
  END ELSE
    CALL F.READ(FN.STANDING.ORDER,Y.TXN.ID,R.STANDING.ORDER,F.STANDING.ORDER,STANDING.ORDER.ERR)
    Y.TXN.CODE  = R.STANDING.ORDER<STO.PAY.METHOD>
    CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
    Y.STO.REJ.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.STO.REJECT.VERSION>
    O.DATA = 'COS ':Y.STO.REJ.COS
  END

  RETURN
*-------------------------------------------------------------------------------------------------------------------
END
