SUBROUTINE REDO.CCRG.B.RL.DEL.LOG(P.IN.CUS.ID)
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
    FN.REDO.CCRG.LOG = 'F.REDO.CCRG.RL.LOG'
    F.REDO.CCRG.LOG  = ''
    R.REDO.CCRG.LOG  = ''
RETURN
*** </region>

*** <region name= OPEN.FILES>
***
OPEN.FILES:
    CALL OPF(FN.REDO.CCRG.RL.LOG, F.REDO.CCRG.RL.LOG)
RETURN
*** </region>

*** <region name= PROCESS>
***
PROCESS:
    SELECT.STATEMENT = 'SELECT ':FN.REDO.CCRG.RL.LOG : ' WITH CUSTOMER.ID EQ ' : P.IN.CUS.ID
    CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.LOG.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE REDO.CCRG.RL.LOG.ID FROM REDO.CCRG.RL.LOG.LIST SETTING REDO.CCRG.RL.LOG.MARK
    WHILE REDO.CCRG.RL.LOG.ID : REDO.CCRG.RL.LOG.MARK
        CALL F.DELETE(FN.REDO.CCRG.RL.LOG,REDO.CCRG.RL.LOG.ID)
    REPEAT

RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= PROCESS>
***
CHECK.PRELIM.CONDITIONS:
RETURN
*** </region>
END
