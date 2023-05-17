*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LOAN.PRD.UPD.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SHANKAR RAJU
* Program Name : REDO.B.STATUS.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - PACS00063146
*Development for Subroutine to perform the initialisation of the batch job
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.LOAN.PRD.UPD.COMMON

  FN.CUST.PRD.LIST = 'F.REDO.CUST.PRD.LIST'
  F.CUST.PRD.LIST  = ''
  CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  RETURN

END
