*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LOAN.CLOSURE.SELECT
*------------------------------------------------------------------------
* Description: This is a Select routine which will run in COB
* and close the accounts of matured AA contracts
*------------------------------------------------------------------------
* Input Arg: N/A
* Ouput Arg: N/A
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE          DESCRIPTION
* 05-JAN-2012     H GANESH              PACS00174524 - B.43 Initial Draft
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.B.LOAN.CLOSURE.COMMON


  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------


  Y.LIST.OF.IDS = ''
  Y.LAST.WRKNG.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  SEL.CMD = 'SELECT ':FN.REDO.CONCAT.AA.CLOSURE.DAYS:' WITH @ID GT ':Y.LAST.WRKNG.DATE:' AND @ID LE ':TODAY
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
  Y.LOOP = 1
  LOOP
  WHILE Y.LOOP LE SEL.NOR
    Y.ID = SEL.LIST<Y.LOOP>
    CALL F.READ(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.ID,R.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS,CNCT.ERR)
    Y.LIST.OF.IDS<-1> = R.REDO.CONCAT.AA.CLOSURE.DAYS
    Y.LOOP++
  REPEAT

  CALL BATCH.BUILD.LIST('',Y.LIST.OF.IDS)

  RETURN
END
