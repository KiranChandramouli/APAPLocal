*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.BY.MTH.INT(ACCT.ID,CHK.VAL)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an internal call routine called by the batch routine REDO.B.LY.POINT.GEN to get the value
*  based on which the point to be updated in REDO.LY.POINTS is computed for modality type 8
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
* 31-JUL-2011      RMONDRAGON    ODR-2011-06-0243        First Version
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.STMT.ACCT.CR
$INSERT I_REDO.B.LY.POINT.GEN.COMMON

  CHK.VAL     = ''
  GOSUB GET.INT
  CHK.VAL = INT.AMT
  RETURN

*-------
GET.INT:
*-------
*--------------------------------------------------------------
* This section gets the Interest gained in the account each month.
*--------------------------------------------------------------
  ACCT.ACT.ID = ACCT.ID

  INT.AMT = 0

  SEL.STMT.ACCT.CR.CMD = "SELECT ":FN.STMT.ACCT.CR:" WITH @ID LIKE ":ACCT.ACT.ID:"... AND INT.POST.DATE LIKE ":TODAY[1,6]:"..."
  CALL EB.READLIST(SEL.STMT.ACCT.CR.CMD,STMT.ACCT.CR.LIST,'',ID.CNT,'')

  LOOP
    REMOVE STMT.ACCT.CR.ID FROM STMT.ACCT.CR.LIST SETTING STMT.ACCT.CR.POS
  WHILE STMT.ACCT.CR.ID:STMT.ACCT.CR.POS
    R.STMT = ''
    CALL F.READ(FN.STMT.ACCT.CR,STMT.ACCT.CR.ID,R.STMT,F.STMT.ACCT.CR,STMT.ACCT.CR.ERR)
    IF R.STMT THEN
      INT.AMT += R.STMT<IC.STMCR.TOTAL.INTEREST>
    END
  REPEAT

  RETURN
END
