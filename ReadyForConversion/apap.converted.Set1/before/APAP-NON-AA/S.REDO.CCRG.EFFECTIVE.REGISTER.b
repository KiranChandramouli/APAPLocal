*-----------------------------------------------------------------------------
* <Rating>-29</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.EFFECTIVE.REGISTER(P.IN.CUS.ID, P.IO.MSG.ERR)
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program update the LINK field of the REDO.CCRG.RL.EFFECTIVE
* for every record of the consulted customer
*
* Linked With:
*             ROUTINE REDO.CCRG.B.POP
*
* In Parameter:
*               P.IN.CUS.ID: Code consulted customer
*
* Out Parameter:
*               P.IO.MSG.ERR: This parameter can receive a error message generated in the populate process
*                             and/or can send a error message generated in this routine to save in the log
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 11/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              anoriega@temenos.com
*
*--------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.CCRG.B.POP.COMMON
*
$INSERT I_F.REDO.CCRG.RL.EFFECTIVE
*
*--------------------------------------------------------------------------------------------
*
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------

* Select all process for the consulted customer P.IN.CUS.ID
  Y.SEL.CMD    = 'SELECT ': FN.REDO.CCRG.RL.EFFECTIVE: ' WITH CUSTOMER.ID EQ ': P.IN.CUS.ID
  REDO.CCRG.RL.EFFECTIVE.LIST = ''
  LIST.NAME    = ''
  SELECTED     = ''
  SYS.RTN.CODE = ''
  CALL EB.READLIST(Y.SEL.CMD,REDO.CCRG.RL.EFFECTIVE.LIST,LIST.NAME,SELECTED,SYS.RTN.CODE)

* Validate exist record in monitor application REDO.CCRG.RL.EFFECTIVE
  IF NOT(REDO.CCRG.RL.EFFECTIVE.LIST) THEN
    P.IO.MSG.ERR<1> = 'ST-REDO.CCRG.NOT.EXIST.EFFECTIVE.REC'
    P.IO.MSG.ERR<2> =  P.IN.CUS.ID : VM : FN.REDO.CCRG.RL.EFFECTIVE
  END ELSE
* Reload the LINK field of each record in the process for the consulted customer P.IN.CUS.ID
    Y.EFF.ID  = ''
    Y.MARK    = ''
    REDO.CCRG.RL.EFFECTIVE.LIST = REDO.CCRG.RL.EFFECTIVE.LIST
    LOOP
      REMOVE Y.EFF.ID FROM REDO.CCRG.RL.EFFECTIVE.LIST SETTING Y.MARK
    WHILE Y.EFF.ID : Y.MARK
* Read record
      R.REDO.CCRG.RL.EFFECTIVE = ''
      YERR = ''
      CALL F.READ(FN.REDO.CCRG.RL.EFFECTIVE,Y.EFF.ID,R.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE,YERR)
* Update record
      R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.START.DATE> = Y.DATE
      IF NOT(P.IO.MSG.ERR) THEN
* If the process don´t have error then can show the enquiries
        R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.1>     = 'ENQ E.REDO.CCRG.RL.BAL.MAIN'
        R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.2>     = ''
      END ELSE
* If the process has error then has to show the log
        R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.1> = ''
        R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.2> = 'ENQ E.REDO.CCRG.RL.LOG'
      END
* Write
*Tus Start
      CALL F.WRITE(FN.REDO.CCRG.RL.EFFECTIVE,Y.EFF.ID,R.REDO.CCRG.RL.EFFECTIVE)
    REPEAT
  IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
    CALL JOURNAL.UPDATE('')
  END
*Tus End
  END

  RETURN
*--------------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

* Initialize variables

  CALL ADD.DATE.TIME
  Y.DATE = COMI

  RETURN
*--------------------------------------------------------------------------------------------

END
