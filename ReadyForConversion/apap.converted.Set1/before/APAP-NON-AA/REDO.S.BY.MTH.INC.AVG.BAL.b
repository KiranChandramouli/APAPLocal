*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.BY.MTH.INC.AVG.BAL(ACCT.ID,CHK.VAL)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an internal call routine called by the batch routine REDO.B.LY.POINT.GEN to get the value
*  based on which the point to be updated in REDO.LY.POINTS is computed for modality type 5
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
* ACCT.ID - ACCOUNT no
* OUT :
* CHK.VAL - Value based on which the point to be updated in REDO.LY.POINTS is computed
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : REDO.B.LY.POINT.GEN
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BALANCE.MOVEMENT
$INSERT I_REDO.B.LY.POINT.GEN.COMMON

  CHK.VAL = ''
  GOSUB GET.CURR.ADJ.AVG.BAL
  GOSUB GET.PREV.ADJ.AVG.BAL
  CHK.VAL = ADJ.AVG.BAL.CUR - ADJ.AVG.BAL.PRE
  RETURN
*--------------------
GET.CURR.ADJ.AVG.BAL:
*--------------------
*--------------------------------------------------------------
* This section calculates the ADJ.AVG.BAL for the current month
*--------------------------------------------------------------
  ADJ.AVG.BAL.CUR = ''
  BL.MV.CUR.ID = ACCT.ID:'*':TODAY[1,6]
  R.BALANCE.MOVEMENT = ''
  CALL F.READ(FN.BALANCE.MOVEMENT,BL.MV.CUR.ID,R.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT,BL.MV.ERR)
  ADJ.AVG.BAL.CUR = R.BALANCE.MOVEMENT<BL.MV.ADJ.AVG.BALANCE>
  RETURN
*--------------------
GET.PREV.ADJ.AVG.BAL:
*--------------------
*----------------------------------------------------------------
*  This section calculates the ADJ.AVG.BAL for the previous month
*----------------------------------------------------------------
  ADJ.AVG.BAL.PRE = ''
  R.BALANCE.MOVEMENT = ''
  IF TODAY[5,2] NE 01 THEN
    BL.MV.PRE.ID = ACCT.ID:'*':TODAY[1,4]:PREV.MTH
  END ELSE
    BL.MV.PRE.ID = ACCT.ID:'*':PREV.YEAR:'12'
  END
  CALL F.READ(FN.BALANCE.MOVEMENT,BL.MV.PRE.ID,R.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT,BL.MV.ERR)
  ADJ.AVG.BAL.PRE = R.BALANCE.MOVEMENT<BL.MV.ADJ.AVG.BALANCE>
  RETURN
END
