* @ValidationCode : MjoxMzQxNjU1Mjc0OkNwMTI1MjoxNjg0ODQyMTU2ODI1OklUU1M6LTE6LTE6LTY2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -66
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE V.REDO.COL.TSA.INPUT
******************************************************************************
*
*   REDO COLLECTOR - Version Routine - Input Routine
*
*   - This routines has to check if the version was called on INPUT or AUTHORISE mode, and the
*   Local.Field COMMENTS is not blank
*   - Also, the routines has to check if the user has not changed the old comments
* =============================================================================
*
*    First Release : TAM
*    Developed for : APAP
*    Developed by  : TAM
*    Date          : 2010-11-16 - C.1
*
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, SM TO @SM, I TO I.WAR
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
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
        IF E THEN
            ETEXT = E
            CALL STORE.END.ERROR
        END
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
    IF V$FUNCTION MATCHES "I" THEN
        Y.TOTAL.OLD = DCOUNT(R.OLD(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS>,@SM)
        Y.TOTAL.NEW = DCOUNT(R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS>,@SM)
        IF Y.TOTAL.OLD GT Y.TOTAL.NEW THEN
            AF = TS.TSM.LOCAL.REF
            AV = Y.COL.COMMENTS.POS
            E = yOldCommentsChanged
            RETURN
        END
        FOR I.VAR = 1 TO Y.TOTAL.OLD ;*AUTO R22 CODE CONVERSION
            IF R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.COMMENTS.POS,I.VAR> NE R.OLD(TS.TSM.LOCAL.REF)<1,Y.COL.COMMENTS.POS,I.VAR> THEN
                AF = TS.TSM.LOCAL.REF
                AV = Y.COL.COMMENTS.POS
                E = yOldCommentsChanged
                RETURN
            END
        NEXT
        FOR I.VAR = 1 TO Y.TOTAL.NEW ;*AUTO R22 CODE CONVERSION
            IF R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS,I.VAR> EQ "" THEN
                R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.INPUTTER.POS,-1> = OPERATOR
            END
        NEXT
*        IF R.NEW(TS.TSM.SERVICE.CONTROL) EQ "START" THEN
        IF R.NEW(TS.TSM.LOCAL.REF)<1,Y.COL.COMMENTS.POS, Y.TOTAL.NEW> EQ "" THEN
            AF = TS.TSM.LOCAL.REF
            AV = Y.COL.INPUTTER.POS
            E = yCommentMandatory
            RETURN
        END
*        END
    END

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    yOldCommentsChanged = "ST-REDO.COL.OLD.COMMENTS.CHANGE" : @VM : "OLD COMMENTS MUST NOT BE CHANGED"
    yCommentMandatory  = "ST-REDO.COL.COMMENTS.MISSING" : @VM : "COMMENTS IS MANDATORY FIELD"
    PROCESS.GOAHEAD = 1
    Y.COL.INPUTTER.POS = ""
    Y.COL.COMMENTS.POS = ""
    Y.LOCAL.FIELDS = "COL.INPUTTER" : @VM : "COL.COMMENTS"
    CALL MULTI.GET.LOC.REF("TSA.SERVICE", Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)
    FOR I.VAR = 1 TO 2 ;*AUTO R22 CODE CONVERSION
        IF Y.LOCAL.FIELDS.POS<1,I.VAR> EQ "" THEN
            E = "ST-REDO.COL.LOCAL.FIELD.NO.DEF" : @VM : " LOCAL FIELD -&- WAS NOT DEF FOR APPLICATION -&-"
            E<2> =  Y.LOCAL.FIELDS<I.VAR> : @VM : "TSA.SERVICE"
            CALL STORE.END.ERROR
            PROCESS.GOAHEAD = 0
            BREAK
        END
    NEXT I.VAR ;*AUTO R22 CODE CONVERSION
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
