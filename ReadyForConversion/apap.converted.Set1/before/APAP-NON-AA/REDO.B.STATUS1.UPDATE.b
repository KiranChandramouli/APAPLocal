*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.STATUS1.UPDATE
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.STATUS1.UPDATE
*------------------------------------------------------------------
* Description : This is the update rotuine which will find out the status
* of the customer accounts based on a particular time period
*------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              05-07-2011       PACS00084781       Selecting only saving,current,sweep account
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.REDO.UPD.ACC.LIST

  GOSUB SEL.PROCESS
  GOSUB PROCESS.ALL
  RETURN
*-------------------------------------------------------------------------
SEL.PROCESS:
*-------------------------------------------------------------------------
  FN.REDO.UPD.ACC.LIST = 'F.REDO.UPD.ACC.LIST'
  F.REDO.UPD.ACC.LIST = ''
  CALL OPF(FN.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST)
  
  Y.LAST.WRKN.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  Y.TODAY = R.DATES(EB.DAT.TODAY)
  
  *SEL.CMD = 'SELECT ':FN.REDO.UPD.ACC.LIST:' WITH @ID LIKE ':Y.LAST.WRKN.DATE:'-...'
   SEL.CMD = 'SELECT ':FN.REDO.UPD.ACC.LIST:' WITH @ID LIKE ':Y.TODAY:'-...'

   CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)
  RETURN
*-------------------------------------------------------------------------
PROCESS.ALL:
*-------------------------------------------------------------------------
  Y.ACCOUNT.NUMBER = ''
  LOOP
    REMOVE Y.ID FROM SEL.LIST SETTING POS
  WHILE Y.ID:POS
    CALL F.READ(FN.REDO.UPD.ACC.LIST,Y.ID,R.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST,Y.ERR.R)
    Y.ACCOUNT.NUMBER<-1> = R.REDO.UPD.ACC.LIST
    CALL F.DELETE(FN.REDO.UPD.ACC.LIST,Y.ID)
  REPEAT
  CHANGE VM TO FM IN Y.ACCOUNT.NUMBER
  R.REDO.UPD.ACC.LIST.BK<AL.ACCOUNT> = Y.ACCOUNT.NUMBER
  IF Y.ACCOUNT.NUMBER THEN
    *CALL F.WRITE(FN.REDO.UPD.ACC.LIST,Y.LAST.WRKN.DATE,R.REDO.UPD.ACC.LIST.BK)
	CALL F.WRITE(FN.REDO.UPD.ACC.LIST,Y.TODAY,R.REDO.UPD.ACC.LIST.BK)
  END
  RETURN
END
