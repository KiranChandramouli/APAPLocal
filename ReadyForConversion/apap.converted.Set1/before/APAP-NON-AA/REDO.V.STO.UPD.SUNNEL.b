*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.STO.UPD.SUNNEL(Y.FT.ID,Y.FT.STATUS)
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.STO.UPD.SUNNEL.DETAILS
*------------------------------------------------------------------------------------------------------------------
*Description       :This routine updates sunnel after FT is executed
*Linked With       :
*In  Parameter     :
*Out Parameter     :
*ODR  Number       : 2010-08-0031
*-----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER

  IF Y.FT.STATUS EQ 'IHLD' THEN
    RETURN
  END
  GOSUB INIT
  RETURN
*-------------------------------------------------------------
*********
INIT:
*********

  FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER=''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
  CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR)
  MATPARSE R.NEW FROM R.FUNDS.TRANSFER
  IF R.NEW(FT.CREDIT.CURRENCY) EQ 'DOP' THEN
    Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.DOP'
  END
  ELSE
    Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.USD'
  END
  PGM.VERSION='FUNDS.TRANSFER'
  APPLICATION='FUNDS.TRANSFER'
  CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
  MATBUILD R.FUNDS.TRANSFER FROM R.NEW
  Y.ID.NEW=ID.NEW
  CALL REDO.STO.NCF(Y.ID.NEW,R.FUNDS.TRANSFER)
  RETURN
END
