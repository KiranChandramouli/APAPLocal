*----------------------------------------------------------------------------------
* <Rating>-20</Rating>
*----------------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.SAVING.ACCT
*----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath G
*Program   Name    :REDO.V.VAL.SAVING.ACCT
*----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                 Reference            Description
* 16-APR-2010          Bharath G           PACS00055029         Initial Creation
* 14-Mar-2018          Gopala Krishnan R   PACS00646692         Code Updation
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.FT.TT.TRANSACTION
*----------------------------------------------------------------------------------
  GOSUB INIT
  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    GOSUB PROCESS.FT
  END
  IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
    GOSUB PROCESS.REDO.FT.TT
  END
  RETURN
*----------------------------------------------------------------------------------
INIT:
*----

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  R.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN
*----------------------------------------------------------------------------------
PROCESS.FT:
*---------
*
  Y.AC.ID = R.NEW(FT.CREDIT.ACCT.NO)

  CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

  IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' OR R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> NE '' THEN
    AF = FT.CREDIT.ACCT.NO
    ETEXT = "EB-NOT.SAVING.AC"
    CALL STORE.END.ERROR
  END

  RETURN
*----------------------------------------------------------------------------------
PROCESS.REDO.FT.TT:
*---------
*
  Y.AC.ID = R.NEW(FT.TN.CREDIT.ACCT.NO)

  CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

  IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' OR R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> NE '' THEN
    AF = FT.TN.CREDIT.ACCT.NO
    ETEXT = "EB-NOT.SAVING.AC"
    CALL STORE.END.ERROR
  END

  RETURN
END

