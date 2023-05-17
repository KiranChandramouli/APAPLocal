*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REV.NAB.ACCT.REACH.WOF.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.REV.NAB.ACCT.REACH.WOF.LOAD
*-----------------------------------------------------------------
* Description : This routine is used to reverse contingent cus a/c and internal ac
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      23-OCT-2011          WOF ACCOUTING - PACS00202156
*-----------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.REV.NAB.ACCT.REACH.WOF.COMMON

MAIN:

  FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
  F.REDO.AA.NAB.HISTORY = ''
  CALL OPF(FN.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
  F.REDO.AA.INT.CLASSIFICATION = ''

  Y.SYS.ID = 'SYSTEM'
*TUS START
*  CALL F.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.SYS.ID,R.REDO.AA.INT.CLASSIFICATION,F.REDO.AA.INT.CLASSIFICATION,CLASS.ERR) 
CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.SYS.ID,R.REDO.AA.INT.CLASSIFICATION,CLASS.ERR) 
*TUS END

  FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
  F.REDO.CONCAT.ACC.NAB = ''
  CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

  RETURN

END
