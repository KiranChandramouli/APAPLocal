*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AA.POOL.RATE.UPDATE.LOAD
*------------------------------------------------------
*Description: This batch routine is to update the pool rate
*             for back to back loans which has deposit as a collateral.
*------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AA.POOL.RATE.UPDATE.COMMON

  GOSUB PROCESS
  RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

  FN.REDO.T.DEP.COLLATERAL = 'F.REDO.T.DEP.COLLATERAL'
  F.REDO.T.DEP.COLLATERAL  = ''
  CALL OPF(FN.REDO.T.DEP.COLLATERAL,F.REDO.T.DEP.COLLATERAL)

  FN.REDO.AZ.CONCAT.ROLLOVER = 'F.REDO.AZ.CONCAT.ROLLOVER'
  F.REDO.AZ.CONCAT.ROLLOVER  = ''
  CALL OPF(FN.REDO.AZ.CONCAT.ROLLOVER,F.REDO.AZ.CONCAT.ROLLOVER)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.LI.COLLATERAL.RIGHT = 'F.LI.COLLATERAL.RIGHT'
  F.LI.COLLATERAL.RIGHT  = ''
  CALL OPF(FN.LI.COLLATERAL.RIGHT,F.LI.COLLATERAL.RIGHT)

  FN.RIGHT.COLLATERAL = 'F.RIGHT.COLLATERAL'
  F.RIGHT.COLLATERAL  = ''
  CALL OPF(FN.RIGHT.COLLATERAL,F.RIGHT.COLLATERAL)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.COLLATERAL = 'F.COLLATERAL'
  F.COLLATERAL  = ''
  CALL OPF(FN.COLLATERAL,F.COLLATERAL)


  LOC.REF.APPLICATION   = "AA.PRD.DES.INTEREST":FM:"COLLATERAL"
  LOC.REF.FIELDS        = 'L.AA.POOL.RATE':FM:'L.COL.NUM.INSTR'
  LOC.REF.POS           = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AA.POOL.RATE = LOC.REF.POS<1,1>
  POS.L.COL.NUM.INSTR= LOC.REF.POS<2,1>



  CALL F.READ(FN.REDO.AZ.CONCAT.ROLLOVER,TODAY,R.REDO.AZ.CONCAT.ROLLOVER,F.REDO.AZ.CONCAT.ROLLOVER,RLL.ERR)




  RETURN
END
