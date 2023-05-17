SUBROUTINE S.REDO.CCRG.RL.DEL.LOG(P.IN.CUS.ID)
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
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END

RETURN
*** <region name= INITIALISE>
***
INITIALISE:
    PROCESS.GOAHEAD = 1
    FN.REDO.CCRG.RL.LOG = 'F.REDO.CCRG.RL.LOG'
    F.REDO.CCRG.RL.LOG  = ''
    R.REDO.CCRG.RL.LOG  = ''
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
* Generate the SELECT.STATEMENT
    SELECT.STATEMENT = 'SELECT ':FN.REDO.CCRG.RL.LOG : ' WITH F2 EQ ' :P.IN.CUS.ID
    CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.LOG.LIST,LIST.NAME,Y.NO.OF.REG,Y.ERR)

    IF Y.NO.OF.REG THEN
        LOOP
            REMOVE REDO.CCRG.RL.LOG.ID FROM REDO.CCRG.RL.LOG.LIST SETTING REDO.CCRG.RL.LOG.MARK
        WHILE REDO.CCRG.RL.LOG.ID : REDO.CCRG.RL.LOG.MARK
*Tus Start
            CALL F.DELETE(FN.REDO.CCRG.RL.LOG,REDO.CCRG.RL.LOG.ID)
        REPEAT

        IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
            CALL JOURNAL.UPDATE('')
        END
*Tus End

    END
RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
***
CHECK.PRELIM.CONDITIONS:
RETURN
*** </region>
END
