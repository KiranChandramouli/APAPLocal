*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LAPAP.CONSULTAR.CATEGORY.DEPOSIT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : LAPAP.CONSULTAR.CATEGORY.DEPOSIT

*--------------------------------------------------------------------------------
* Description: This validation routine is to look for the category linked to a category for reinvested deposit
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                REFERENCE         DESCRIPTION
* 03-OCT-2022       Estalin Valerio                      INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT T24.BP I_COMMON
$INSERT T24.BP I_EQUATE
$INSERT T24.BP I_System
$INSERT T24.BP I_F.ACCOUNT
$INSERT T24.BP I_F.AZ.PRODUCT.PARAMETER


 IF MESSAGE EQ '' THEN
    GOSUB INIT
    GOSUB PROCESS
 RETURN

 END

 
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

  FN.APP = 'F.AZ.PRODUCT.PARAMETER'
  F.APP = ''
  CALL OPF(FN.APP,F.APP)

  LOC.REF.APPLICATION="ACCOUNT":FM:"AZ.PRODUCT.PARAMETER"
  LOC.REF.FIELDS='L.AZ.APP':VM:'L.AC.AZ.ACC.REF':VM:'L.AC.STATUS1':FM:'L.AZ.RE.INV.CAT'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

  POS.L.AZ.RE.INV.CAT = LOC.REF.POS<2,1>

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  Y.APP.ID = COMI
  CALL CACHE.READ(FN.APP,Y.APP.ID,R.APP,APP.ERR)
  COMI = R.APP<AZ.APP.LOCAL.REF,POS.L.AZ.RE.INV.CAT>

  RETURN

END
