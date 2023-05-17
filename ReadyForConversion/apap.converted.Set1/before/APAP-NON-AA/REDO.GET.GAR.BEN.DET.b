*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.GAR.BEN.DET(Y.BEN)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.GAR.BEN.DET
* ODR NUMBER    : PACS00133294
*----------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the name as per the requirement
* In parameter  :
* out parameter : Y.NAME
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-sept-2011      prabhu           PACS00133294
*----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER


  GOSUB PROCESS.FILE


  RETURN

*----------------------------------------------------------------------------------------------------
PROCESS.FILE:
*----------------------------------------------------------------------------------------------------

  Y.AMOUNT =     R.NEW(FT.DEBIT.AMOUNT)
  Y.AMOUNT =  TRIMB(FMT(Y.AMOUNT,'L2,#19'))
  Y.BEN= FMT(Y.BEN,'L#65'):'    ':Y.AMOUNT

  RETURN
END
