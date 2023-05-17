*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REINV.BAL.UPDATE.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.BAL.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Description: This is the load routine for REDO.B.REINV.BAL.UPDATE
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 05-Jul-2011    H GANESH      PACS00072695_N.11 INITIAL CREATION
*
*----------------------------------------------------------------------------
*TUS START
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.REINV.BAL.UPDATE.COMMON
*TUS END

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  LOC.REF.APPLICATION="ACCOUNT":FM:'AZ.ACCOUNT'
  LOC.REF.FIELDS='L.AC.AV.BAL':FM:'L.AZ.REIVSD.INT'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AC.AV.BAL = LOC.REF.POS<1,1>
  POS.L.AZ.REIVSD.INT = LOC.REF.POS<2,1>

  RETURN
END
