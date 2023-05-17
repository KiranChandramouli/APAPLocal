*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FMT.PI.VALUE

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GURU DEV
* Program Name : REDO.FMT.PI.VALUE
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
*Modification History:
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26 Mar 2011    GURU DEV      PACS00033054      Initial Draft
* 25 May 2011    H Ganesh      PACS00060847      LREF.POS has been initialised
*--------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.PERIODIC.INTEREST
$INSERT I_F.AZ.PRODUCT.PARAMETER

  GOSUB PROCESS
  RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------


  LREF.APP='AZ.PRODUCT.PARAMETER'
  LREF.FIELD='L.AP.RENEW.KEY'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
  AZ.RENEW.KEY.POS = LREF.POS<1,1>

  IF APPLICATION EQ 'AZ.PRODUCT.PARAMETER' THEN
    Y.RENEWAL.KEY = R.NEW(AZ.APP.LOCAL.REF)<1,AZ.RENEW.KEY.POS>
    Y.RENEWAL.KEY = FMT(Y.RENEWAL.KEY,"2'0'R")
    R.NEW(AZ.APP.LOCAL.REF)<1,AZ.RENEW.KEY.POS> = Y.RENEWAL.KEY
  END

  RETURN
END
