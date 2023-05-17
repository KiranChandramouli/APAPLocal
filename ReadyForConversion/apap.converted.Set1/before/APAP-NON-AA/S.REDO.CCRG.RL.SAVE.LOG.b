*-----------------------------------------------------------------------------
* <Rating>-49</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.RL.SAVE.LOG(P.IN.CUS.ID,P.IN.SOURCE.INFO, P.IN.ERR.MSG)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine insert the messages in REDO.CCRG.RL.LOG application
*
*  Input Param:
*  ------------
*  P.IN.CUS.ID:
*            Customer code to search
*  P.IN.SOURCE.INFO:
*            <1> = Routine name wich generate the error
*            <2> = Label name where the error is generated
*  P.IN.ERR.MSG:
*            Error message
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011.04.06 - APAP B5 : ODR-2011-03-0154
*                                   First Version
*-----------------------------------------------------------------------------
* 05/01/2012 - avelasco@temenos.com
*              PACS00172824 -Control write on log file
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*-----------------------------------------------------------------------------
  COMMON/LOG.CCRG/ FN.REDO.CCRG.RL.LOG, F.REDO.CCRG.RL.LOG
*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB OPEN.FILES
    GOSUB PROCESS
  END

  RETURN
*** <region name= INITIALISE>
*** <desc>Initialise the variables</desc>
INITIALISE:
  PROCESS.GOAHEAD     = 1
  FN.REDO.CCRG.RL.LOG = ''
  F.REDO.CCRG.RL.LOG  = ''
  R.REDO.CCRG.RL.LOG  = ''
  Y.ROUTINE           = P.IN.SOURCE.INFO<1>
  Y.PARAGRAPH         = P.IN.SOURCE.INFO<2>
  Y.ERR.MSG           = P.IN.ERR.MSG

  RETURN
*** </region>

*** <region name= OPEN.FILES>
*** <desc>Open files</desc>
OPEN.FILES:
  IF NOT(FN.REDO.CCRG.RL.LOG) THEN
    FN.REDO.CCRG.RL.LOG = 'F.REDO.CCRG.RL.LOG'
    CALL OPF(FN.REDO.CCRG.RL.LOG, F.REDO.CCRG.RL.LOG)
  END

  RETURN
*** </region>

*** <region name= PROCESS>
*** <desc>EXecute the process</desc>
PROCESS:
  CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
  Y.ID = P.IN.CUS.ID : '-' : Y.UNIQUE.TIME

  R.REDO.CCRG.RL.LOG<1> = Y.ID
  R.REDO.CCRG.RL.LOG<2> = P.IN.CUS.ID
  R.REDO.CCRG.RL.LOG<3> = Y.ROUTINE:'-':Y.PARAGRAPH:'-':Y.ERR.MSG
  CALL OCOMO("Rutina S.REDO.CCRG.RL.SAVE.LOG->" :Y.ID:'->':R.REDO.CCRG.RL.LOG)
*CALL F.WRITE(FN.REDO.CCRG.RL.LOG,Y.ID,R.REDO.CCRG.RL.LOG)
*Control error on write
  WRITE R.REDO.CCRG.RL.LOG TO F.REDO.CCRG.RL.LOG,Y.ID  SETTING Y.ERR.WRITE ON ERROR
 
    CALL OCOMO("Error en write S.REDO.CCRG.RL.SAVE.LOG->" :Y.ID:'-> ':Y.ERR.WRITE)
  END


  RETURN
*** </region>

*** <region name= CHECK.PRELIM.CONDITIONS>
*** <desc>Check prelim conditions</desc>
CHECK.PRELIM.CONDITIONS:
  IF NOT(P.IN.CUS.ID) OR NOT(P.IN.ERR.MSG) THEN
    PROCESS.GOAHEAD = 0
  END
  RETURN
*** </region>

END
