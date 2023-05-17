*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.BENFIC.NAME(VAR.BEN.NAME)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.BENF.NAME
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the name as per the requirement
* In parameter  :
* out parameter : Y.NAME
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-sept-2011      JEEVA T        PACS00127058
*----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.RELATION
$INSERT I_F.CUSTOMER
$INSERT I_F.VERSION
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.PRINT.CHQ.LIST
$INSERT I_F.TELLER


  GOSUB PROCESS.FILE


  RETURN

*----------------------------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------------------------

  VAR.AC.ID = ''
  VAR.BEN.NAME = ''

  Y.BENEFIC.NAME = R.NEW(PRINT.CHQ.LIST.BENEFICIARY)
  CHANGE VM TO FM IN Y.BENEFIC.NAME

  VAR.BEN.NAME  = Y.BENEFIC.NAME<1>
  VAR.BEN.NAME2 = Y.BENEFIC.NAME<2>
  IF NOT(VAR.BEN.NAME2) THEN
    VAR.BEN.NAME = ''
  END

  RETURN
END
