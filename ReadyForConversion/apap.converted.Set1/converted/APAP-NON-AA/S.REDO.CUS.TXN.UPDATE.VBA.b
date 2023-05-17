SUBROUTINE S.REDO.CUS.TXN.UPDATE.VBA
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------
*  Routine customer transaction update before authorization
*
*  Input Param:
*  ------------
*  P.IN.REQUEST:
*
*  Output Param:
*  ------------
*  E:
*            Error message
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
*
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION

    $INSERT I_F.REDO.CUS.TXN.PARAM
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
    $INSERT I_REDO.CCRG.B.EXT.COMMON
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB  OPEN.FILES
        GOSUB PROCESS
    END

RETURN

*** <region name= INITIALISE>
*** <desc>Initialise the variables</desc>
****
INITIALISE:
    PROCESS.GOAHEAD = 1
    E               = ''
    Y.IS.INPUT      = ''

    FN.REDO.CUS.TXN.PARAM = 'F.REDO.CUS.TXN.PARAM'
    F.REDO.CUS.TXN.PARAM  = ''
    R.REDO.CUS.TXN.PARAM  = ''
    REDO.CUS.TXN.PARAM.ID = 'SYSTEM'
RETURN
*** </region>

*** <region name= OPEN.FILES>
*** Open the necessary files
OPEN.FILES:
    CALL OPF(FN.REDO.CUS.TXN.PARAM,F.REDO.CUS.TXN.PARAM)
RETURN
*** </region>


*** <region name= PROCESS>
***
PROCESS:

* IF OPERATOR EQ "CHERRERA001" THEN
*  DEBUG
* END

    CALL CACHE.READ(FN.REDO.CUS.TXN.PARAM,REDO.CUS.TXN.PARAM.ID,R.REDO.CUS.TXN.PARAM,YERR)

    IF NOT(R.REDO.CUS.TXN.PARAM) THEN
        ETEXT = K.REC.NOT.FOUND : @FM : REDO.CUS.TXN.PARAM.ID : @VM: 'REDO.CUS.TXN.PARAM'
        E = ETEXT
        CALL STORE.END.ERROR

        E = K.REC.NOT.FOUND
        E<2> = REDO.CUS.TXN.PARAM.ID : @VM: 'REDO.CUS.TXN.PARAM'

        RETURN
    END

* Check this because i'am not sure

    Y.APP.ID = APPLICATION

* Locate the application
    LOCATE Y.APP.ID IN R.REDO.CUS.TXN.PARAM<REDO.CUS.TP.APPLICATION,1> SETTING Y.POS THEN
* Validate if application is equal SEC.TRADE and function I
        IF (V$FUNCTION EQ 'I' AND Y.APP.ID EQ 'SEC.TRADE') OR (V$FUNCTION EQ 'A' AND Y.APP.ID NE 'SEC.TRADE') OR (V$FUNCTION EQ 'I' AND Y.APP.ID NE 'SEC.TRADE' AND R.VERSION(EB.VER.NO.OF.AUTH) EQ 0 )  THEN
*         * Create the OFS message
            Y.OFS.MSG = ''
            Y.RECORD.STATUS = ''
            Y.RECORD.STATUS = R.NEW(V-8)

* Verify that always exists a value
            IF NOT(Y.RECORD.STATUS) THEN
                Y.RECORD.STATUS = 'INAU'
            END

            Y.RESULT = ''
            Y.MSG = Y.APP.ID : ',' : Y.RECORD.STATUS : ',' : ID.NEW

            CALL S.REDO.CUS.OFS.TXN.UPDATE(Y.MSG, Y.RESULT)
        END
    END

RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
***
CHECK.PRELIM.CONDITIONS:
* Check if the action is INPUT or REVERSE
* Record status R.NEW(V-8)
* Curr no R.NEW(V-7)

    Y.IS.INPUT = R.NEW(V-8)[1,3] EQ 'INA'

    IF Y.IS.INPUT AND R.NEW(V-7) GT 1 THEN
        PROCESS.GOAHEAD = 0
    END

RETURN
*** </region>
END
