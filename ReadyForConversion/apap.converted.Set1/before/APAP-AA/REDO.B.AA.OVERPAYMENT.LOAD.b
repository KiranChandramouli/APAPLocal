*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AA.OVERPAYMENT.LOAD
*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan.
*-------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AA.OVERPAYMENT.COMMON

  GOSUB PROCESS
  RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

  FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
  F.REDO.AA.OVERPAYMENT  = ''
  CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

  FN.REDO.AA.OVERPAYMENT.PARAM = 'F.REDO.AA.OVERPAYMENT.PARAM'
  F.REDO.AA.OVERPAYMENT.PARAM  = ''
  CALL OPF(FN.REDO.AA.OVERPAYMENT.PARAM,F.REDO.AA.OVERPAYMENT.PARAM)

  CALL CACHE.READ(FN.REDO.AA.OVERPAYMENT.PARAM,'SYSTEM',R.REDO.AA.OVERPAYMENT.PARAM,F.REDO.AA.OVERPAYMENT.PARAM)

  RETURN
END
