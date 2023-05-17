SUBROUTINE V.REDO.COL.TSA.RECORD
******************************************************************************
*
*   REDO COLLECTOR - Version Routine - Check.Record
*
*   This routines has to check if the version was called on INPUT mode, and the
*   the RECORD.STATUS is ''
*   In that case the routine has to add a value to local.field COL.INPUTTER
* =============================================================================
*
*    First Release : TAM
*    Developed for : APAP
*    Developed by  : TAM
*    Date          : 2010-11-16 - C.1
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TSA.SERVICE
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*
* Just On Creation
    IF V$FUNCTION NE "I" THEN
        RETURN
    END

    BEGIN CASE
        CASE R.NEW(TS.TSM.RECORD.STATUS) EQ ""
* Add new operator
            R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS,-1> = OPERATOR
            R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.COMMENTS.POS,-1> = ""
        CASE R.NEW(TS.TSM.RECORD.STATUS) MATCHES "IHLD" : @VM : "INAU"
* Replace the last operator, and clean its comments
            Y.TOTAL = DCOUNT(R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS>,@SM)
            R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS, Y.TOTAL> = OPERATOR
            R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.COMMENTS.POS, Y.TOTAL> = ""
    END CASE

    IF R.NEW(TS.TSM.SERVICE.CONTROL) EQ "" THEN
        R.NEW(TS.TSM.SERVICE.CONTROL) = "START"
    END

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
    Y.COL.INPUTTER.POS = ""
    Y.COL.COMMENTS.POS = ""
    Y.LOCAL.FIELDS = "COL.INPUTTER" : @VM : "COL.COMMENTS"
    CALL MULTI.GET.LOC.REF("TSA.SERVICE", Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)
    FOR I.VAR = 1 TO 2
        IF Y.LOCAL.FIELDS.POS<1,I.VAR> EQ "" THEN
            E = "ST-REDO.COL.LOCAL.FIELD.NO.DEF" : @VM : " LOCAL FIELD -&- WAS NOT DEF FOR APPLICATION -&-"
            E<2> =  Y.LOCAL.FIELDS<I.VAR> : @VM : "TSA.SERVICE"
            CALL STORE.END.ERROR
            PROCESS.GOAHEAD = 0
            BREAK
        END
    NEXT I.VAR
    Y.COL.INPUTTER.POS = Y.LOCAL.FIELDS.POS<1,1>
    Y.COL.COMMENTS.POS = Y.LOCAL.FIELDS.POS<1,2>

*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
*    LOOP
*    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
*        BEGIN CASE
*        CASE LOOP.CNT EQ 1
*
*             IF condicion-de-error THEN
*                PROCESS.GOAHEAD = 0
*                E = "EB-mensaje-de-error-para-la-tabla-EB.ERROR"
*             END
**
*        END CASE
*        LOOP.CNT +=1
*    REPEAT
*
RETURN
*
END
