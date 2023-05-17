*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
*Modification History:
*09/12/2009 - ODR-2009-10-0537
*Development for Subroutine to perform the selection
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 09 AUG 2011    Prabhu N      PACS00100804      Selection routine for table REDO.T.MSG.DET
*--------------------------------------------------------------------------------
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_REDO.B.ESM.STATUS.UPD.COMMON

  SEL.CMD="SELECT " : FN.REDO.T.MSG.DET

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,AZ.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN
END
