*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.DIS.BILL.COND
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will check the mandatory fields
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference          Description
* 05-03-2011        SUDHARSANAN S  PACS00033084       Initial Creation
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.THIRDPRTY.PARAMETER
  IF VAL.TEXT NE "" THEN
    GOSUB INIT
    GOSUB PROCESS
  END
  RETURN
*---*
INIT:
*---*
  FN.REDO.THIRDPRTY.PARAMETER = 'F.REDO.THIRDPRTY.PARAMETER'
  F.REDO.THIRDPRTY.PARAMETER = ''
  CALL OPF(FN.REDO.THIRDPRTY.PARAMETER,F.REDO.THIRDPRTY.PARAMETER)
  RETURN
*------*
PROCESS:
*------*
  VAR.BILL.TYPE = R.NEW(REDO.TP.BILL.TYPE)
  IF NOT(VAR.BILL.TYPE) THEN
    AF = REDO.TP.BILL.TYPE
    ETEXT = 'EB-INPUT.MISSING'
    CALL STORE.END.ERROR
  END
  VAR.BILL.COND  =  R.NEW(REDO.TP.BILL.COND)
  CHANGE VM TO FM IN VAR.BILL.COND
  CNT.BILL.COND = DCOUNT(VAR.BILL.COND,FM)
  FOR CNT =1 TO CNT.BILL.COND
    VAL.BILL.COND  = VAR.BILL.COND<CNT>
    IF NOT(VAL.BILL.COND) THEN
      AF = REDO.TP.BILL.COND
      AV = CNT
      ETEXT = 'EB-INPUT.MISSING'
      CALL STORE.END.ERROR
    END
  NEXT CNT.BILL.COND
  RETURN
*---------------------------------
END
