*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.STO.UPD.NCF(Y.FT.ID,Y.FT.STATUS)
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.STO.UPD.NCF
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
  PGM.VERSION='FUNDS.TRANSFER'
  APPLICATION='FUNDS.TRANSFER'
  MATBUILD R.FUNDS.TRANSFER FROM R.NEW
  Y.ID.NEW=ID.NEW

* PACS00313543 - STO Fix
* CALL REDO.STO.NCF(Y.ID.NEW,R.FUNDS.TRANSFER)
* PACS00313543 - STO Fix


  RETURN
END
