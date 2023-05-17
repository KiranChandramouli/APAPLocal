*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.GEN.ACCMOV.LOAD
*-----------------------------------------------------------------------------
* Initialize COMMON variables and Open required files
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-06-21 : avelasco@temenos.com
*                                   First version
*                      2013-09-13 : rmondragon@temenos.com
*                                   Update to use EB.ACCOUNTING
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.LY.GEN.ACCMOV.COMMON
*-----------------------------------------------------------------------------
* Open files to be used in the XX routine as well as standard variables.
* REDO.LY.PROGRAM
  FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
  F.REDO.LY.PROGRAM  = ''
  CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

* REDO.LY.POINTS.TOT
  FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
  F.REDO.LY.POINTS.TOT  = ''
  CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

* FT.TXN.TYPE.CONDITION
  FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
  F.FT.TXN.TYPE.CONDITION = ''
  CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

* ACCOUNT
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN
*-----------------------------------------------------------------------------
END
