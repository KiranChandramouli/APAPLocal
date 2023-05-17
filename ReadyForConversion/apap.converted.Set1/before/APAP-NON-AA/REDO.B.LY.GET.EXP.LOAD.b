*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.GET.EXP.LOAD
*-----------------------------------------------------------------------------
* Initialize COMMON variables and Open required files
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-06-21 : avelasco@temenos.com
*                                   First version
*                      2013-11-29 : rmondragon@temenos.com
*                                   Update to get next working date needed for
*                                   SELECT routine.
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.B.LY.GET.EXP.COMMON
*-----------------------------------------------------------------------------

  G.DATE = ''
  I.DATE = DATE()
  CALL DIETER.DATE(G.DATE,I.DATE,'')

* Open files to be used in the XX routine as well as standard variables.
* REDO.LY.PROGRAM
  FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
  F.REDO.LY.PROGRAM = ''
  CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

* REDO.LY.POINTS.TOT
  FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
  F.REDO.LY.POINTS  = ''
  CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

* REDO.LY.POINTS.TOT
  FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
  F.REDO.LY.POINTS.TOT  = ''
  CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

* DATES
  FN.DATES = 'F.DATES'
  F.DATES = ''
  CALL OPF(FN.DATES,F.DATES)

  R.REC = ''; DATES.ERR = ''
  ID.TO.CHECK = ID.COMPANY:'-COB'
  CALL F.READ(FN.DATES,ID.TO.CHECK,R.REC,F.DATES,DATES.ERR)
  IF R.REC THEN
    Y.NEXT.WDATE = R.REC<EB.DAT.NEXT.WORKING.DAY>
  END

  RETURN
*-----------------------------------------------------------------------------
END
