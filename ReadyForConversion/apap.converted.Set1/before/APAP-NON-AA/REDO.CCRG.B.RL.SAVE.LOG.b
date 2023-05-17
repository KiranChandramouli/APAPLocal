*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.RL.SAVE.LOG(P.IN.CUS.ID, P.IN.ERR.MSG)
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
*  P.IN.ERR.MSG:
*           Error message in format:
*           <Routine Name> + '-' + <Paragraph Name> + '-' + <Error Message>
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

*** <region name= INITIALISE>
***
INITIALISE:
  PROCESS.GOAHEAD = 1
  FN.REDO.CCRG.SAVE.LOG = 'F.REDO.CCRG.RL.LOG'
  F.REDO.CCRG.SAVE.LOG  = ''
  R.REDO.CCRG.SAVE.LOG  = ''
  RETURN
*** </region>

*** <region name= OPEN.FILES>
***
OPEN.FILES:
  IF NOT(FN.REDO.CCRG.SAVE.LOG) THEN
    CALL OPF(FN.REDO.CCRG.RL.LOG, F.REDO.CCRG.RL.LOG)
  END

  RETURN
*** </region>

*** <region name= PROCESS>
***
PROCESS:
  CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
  Y.ID = P.IN.CUS.ID : '-' : Y.UNIQUE.TIME

  CALL F.WRITE(FN.REDO.CCRG.RL.LOG,REDO.CCRG.RL.LOG.ID,R.REDO.CCRG.RL.LOG)

  RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= PROCESS>
***
CHECK.PRELIM.CONDITIONS:
  IF NOT(P.IN.CUS.ID) OR NOT(P.IN.ERR.MSG) THEN
    PROCESS.GOAHEAD = 0
  END
  RETURN
*** </region>
END
