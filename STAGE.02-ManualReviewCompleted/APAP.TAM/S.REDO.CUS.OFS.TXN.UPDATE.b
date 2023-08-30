$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CUS.OFS.TXN.UPDATE(P.IN.REQUEST,  P.OUT.RESPONSE)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------
*  This routine is invoked through OFS and affect the concat file REDO.CUS.TXN.CONCAT
*
*  Input Param:
*  ------------
*  P.IN.REQUEST:
*            String, split by commas
*            1st position: Application
*            2nd position: Record.Status
*            3rd position: ID.NEW asociated
*  Output Param:
*  ------------
*  P.OUT.RESPONSE:
*            String output with format STATUS,MESSAGE
*            STATUS: 1 OK, 0 ERROR

** 19-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 19-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CUS.TXN.PARAM
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
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
****
INITIALISE:
    PROCESS.GOAHEAD = 1
    P.OUT.RESPONSE  = '1,'
    P.OUT.MSG       = ''

    Y.APP.ID       = P.IN.REQUEST[',',1,1]
    Y.RS           = P.IN.REQUEST[',',2,1]
    Y.ID.NEW       = P.IN.REQUEST[',',3,1]
    Y.RTN.NAME     = ''
    Y.FIELD.NO     = ''
    Y.CUS.FIELD    = ''
    Y.ID.FIELD     = ''
    Y.ID.FIELD.NO  = ''
    Y.MODULE       = ''
    REDO.CUS.TXN.PARAM.ID  = 'SYSTEM'
    R.REDO.CUS.TXN.PARAM   = ''
    FN.REDO.CUS.TXN.PARAM  = 'F.REDO.CUS.TXN.PARAM'
    F.REDO.CUS.TXN.PARAM   = ''
    FN.REDO.CUS.TXN.CONCAT = 'F.REDO.CUS.TXN.CONCAT'
    F.REDO.CUS.TXN.CONCAT  = ''

RETURN
*** </region>

*** <region name= OPEN.FILES>
***
OPEN.FILES:

* Open the files
    CALL OPF(FN.REDO.CUS.TXN.CONCAT,F.REDO.CUS.TXN.CONCAT)


    CALL OPF(FN.REDO.CUS.TXN.PARAM,F.REDO.CUS.TXN.PARAM)
RETURN
*** </region>

*** <region name= READ.DATA>
***
READ.DATA:
* Read the record SYSTEM from REDO.CUS.TXN.PARAM
    CALL CACHE.READ(FN.REDO.CUS.TXN.PARAM,REDO.CUS.TXN.PARAM.ID,R.REDO.CUS.TXN.PARAM,YERR)

* Validate that data exists
    IF NOT(R.REDO.CUS.TXN.PARAM) THEN
        ETEXT = K.REC.NOT.FOUND : @FM : REDO.CUS.TXN.PARAM.ID : @VM: FN.REDO.CUS.TXN.PARAM
        CALL STORE.END.ERROR

* Call to the error message
        CALL S.REDO.GET.EB.ERROR.TXT(K.REC.NOT.FOUND, REDO.CUS.TXN.PARAM.ID : @VM: FN.REDO.CUS.TXN.PARAM,P.OUT.MSG)
        P.OUT.RESPONSE = '0,': P.OUT.MSG
    END

RETURN
*** </region>


*** <region name= PROCESS>
***
PROCESS:



    GOSUB READ.DATA
* DEBUG

* Locate the application
    Y.POS = ''
    LOCATE Y.APP.ID IN R.REDO.CUS.TXN.PARAM<REDO.CUS.TP.APPLICATION,1> SETTING Y.POS THEN
        Y.RTN.NAME = R.REDO.CUS.TXN.PARAM<REDO.CUS.TP.EVALUATOR.RTN, Y.POS>
        Y.CUS.FIELD = R.REDO.CUS.TXN.PARAM<REDO.CUS.TP.CUSTOMER.FIELD, Y.POS>
        Y.FIELD.NO = Y.CUS.FIELD
        GOSUB GET.FIELD.POSITION

* DEBUG
        IF (Y.FIELD.NO GT 0) THEN
            Y.RESULT<1> = R.NEW(Y.FIELD.NO)
            Y.RESULT<2> = Y.ID.NEW
            Y.RESULT<3> = ''
        END

        IF Y.APP.ID EQ "AA.ARRANGEMENT.ACTIVITY" THEN
            Y.ID.FIELD = R.REDO.CUS.TXN.PARAM<REDO.CUS.TP.ID.FIELD, Y.POS>
            Y.ID.FIELD.NO = Y.FIELD.NO
            Y.FIELD.NO = Y.ID.FIELD

            GOSUB GET.FIELD.POSITION
            IF (Y.FIELD.NO GT 0) THEN
                Y.RESULT<2> = R.NEW(Y.FIELD.NO)
            END

            Y.FIELD.NO = Y.ID.FIELD.NO
        END

    END

    IF NOT(Y.POS) THEN
        RETURN
    END

* Call the routine
    CALL @Y.RTN.NAME(Y.APP.ID, Y.ID.NEW, Y.RS, Y.DATA, Y.MODULE)
* DEBUG

    IF NOT(Y.DATA) THEN
*RETURN

        IF (Y.FIELD.NO GT 0) THEN
            Y.RESULT<3> = Y.MODULE
            GOSUB CALLROUTINE
        END
        ELSE
            RETURN
        END
    END
    ELSE

        Y.COUNT = DCOUNT(Y.DATA<1>,@VM)

        FOR I.VAR = 1 TO Y.COUNT ;* R22 Auto conversion
            Y.RESULT<1> = Y.DATA<1,I.VAR> ;* R22 Auto conversion
            Y.RESULT<2> = Y.DATA<2,I.VAR> ;* R22 Auto conversion
            Y.RESULT<3> = Y.DATA<3,I.VAR> ;* R22 Auto conversion
            GOSUB CALLROUTINE
        NEXT I.VAR ;* R22 Auto conversion

    END

RETURN
*** </region>

GET.FIELD.POSITION:

    CALL EB.FIND.FIELD.NO(Y.APP.ID, Y.FIELD.NO)

RETURN

*** Call the routine
CALLROUTINE:
* DEBUG
    IF Y.RS[1,3] EQ 'INA' THEN
        Y.INS = 'I'
    END
    ELSE ;* R22 Auto conversion
        IF Y.RS[1,3] EQ 'RNA' THEN
            Y.INS = 'D'
        END ;* R22 Auto conversion
    END

* Assign new value to Y.ID.NEW


    Y.ID.NEW = Y.RESULT<3>

    IF Y.RESULT<2> NE '' THEN

        Y.ID.NEW := " " : Y.RESULT<2>
    END

    AR.OR.AL = 'AL'

* Call the concat file routine
    IF Y.INS NE '' THEN      ;* Condition for Loan Creation IHLD status
        CALL CONCAT.FILE.UPDATE(FN.REDO.CUS.TXN.CONCAT, Y.RESULT<1>, Y.ID.NEW, Y.INS, AR.OR.AL)
    END
RETURN
*******



*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
***
CHECK.PRELIM.CONDITIONS:
* Verify that application exists
    IF NOT(Y.APP.ID) THEN
        PROCESS.GOAHEAD = 0
        ETEXT = K.PARAMETER.IS.EMPTY : @FM : 'APP.ID' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE'
        CALL STORE.END.ERROR

* Call to the error message
        CALL S.REDO.GET.EB.ERROR.TXT(K.PARAMETER.IS.EMPTY, 'APP.ID' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE',P.OUT.MSG)
        P.OUT.RESPONSE = '0,': P.OUT.MSG
        RETURN
    END

* Verify that record status exists
    IF NOT(Y.RS) THEN
        PROCESS.GOAHEAD = 0
        ETEXT = K.PARAMETER.IS.EMPTY : @FM : 'RECORD.STATUS' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE'
        CALL STORE.END.ERROR

* Call to the error message
        CALL S.REDO.GET.EB.ERROR.TXT(K.PARAMETER.IS.EMPTY, 'RECORD.STATUS' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE',P.OUT.MSG)
        P.OUT.RESPONSE = '0,': P.OUT.MSG
        RETURN
    END

* Verify that id exists
    IF NOT(Y.ID.NEW) THEN
        PROCESS.GOAHEAD = 0
        ETEXT = K.PARAMETER.IS.EMPTY : @FM : 'ID.NEW' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE'
        CALL STORE.END.ERROR

* Call to the error message
        CALL S.REDO.GET.EB.ERROR.TXT(K.PARAMETER.IS.EMPTY, 'ID.NEW' : @VM: 'S.REDO.CUS.OFS.TXN.UPDATE',P.OUT.MSG)
        P.OUT.RESPONSE = '0,': P.OUT.MSG
        RETURN
    END
RETURN
*** </region>
END
