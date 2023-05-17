*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.STMT.DESC.LAST
*------------------------------------------------------------------------------------------------------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.CONV.STMT.DESC
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description

*---------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.TRANSACTION
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.STMT.ENTRY
*

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FN.TRANSACTION = 'F.TRANSACTION'
  F.TRANSACTION  = ''
  CALL OPF(FN.TRANSACTION,F.TRANSACTION)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER  = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER.HIST = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIST  =''
  CALL OPF(FN.FUNDS.TRANSFER.HIST,F.FUNDS.TRANSFER.HIST)

  FN.STMT.ENTRY = 'F.STMT.ENTRY'
  F.STMT.ENTRY  = ''
  CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
  RETURN
********
PROCESS:
********

  Y.IN.DATA = FIELD(O.DATA,'*',2)
  IF Y.IN.DATA EQ 'FT' THEN
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
    IF R.FUNDS.TRANSFER THEN
      Y.REV.TXN.DET = R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS>
    END ELSE
      CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIST,Y.FT.ID,R.FUNDS.TRANSFER.HIST,FT.HIST.ERR)
      Y.REV.TXN.DET = R.FUNDS.TRANSFER.HIST<FT.PAYMENT.DETAILS>
    END
  END

  IF Y.REV.TXN.DET[1,10] EQ 'REVERSO-FT' THEN
    O.DATA = Y.REV.TXN.DET
  END  ELSE
    Y.TXN.CODE =FIELD(O.DATA,'*',1)
    CALL F.READ(FN.TRANSACTION,Y.TXN.CODE,R.TRANSACTION,F.TRANSACTION,TRANSACTION.ERR)
    IF LNGG EQ 2 THEN
      O.DATA = R.TRANSACTION<AC.TRA.NARRATIVE,2>
    END ELSE
      O.DATA = R.TRANSACTION<AC.TRA.NARRATIVE,1>
    END
  END
  RETURN
END
