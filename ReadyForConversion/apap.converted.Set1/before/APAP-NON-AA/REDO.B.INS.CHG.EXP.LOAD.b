*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.INS.CHG.EXP.LOAD
*
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_REDO.B.INS.CHG.EXP.COMMON

MAIN:

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.INSURANCE = 'F.APAP.H.INSURANCE.DETAILS'
  F.INSURANCE = ''
  CALL OPF(FN.INSURANCE,F.INSURANCE)

  PLOL = ''
  F.APLS = 'AA.PRD.DES.CHARGE'
  F.FLDS = 'STATUS.POLICY'
  CALL MULTI.GET.LOC.REF(F.APLS,F.FLDS,PLOL)
  Y.STA.POL = PLOL<1,1>

  RETURN

END
