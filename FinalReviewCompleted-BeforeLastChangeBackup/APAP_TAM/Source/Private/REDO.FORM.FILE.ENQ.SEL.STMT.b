* @ValidationCode : MjotOTcwMDA0NzY0OkNwMTI1MjoxNjgwNzczNjY4NDQ5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FORM.FILE.ENQ.SEL.STMT(IN.FILE,OUT.SELECT)
******************************************************************************************************************
* Component Description:
*    This routine builds the SELECT statement based on the selection criteria from the enquiry
*
* Input/Output
* ------------
* IN.FILE  :  Application Name
* IN.FIXED :  Fixed selection of the enquiry
* IN.SORT  :  Sorting field name
* OUT.SELECT : Select statement
*
* Dependencies
* ------------
* CALLS:
*
* CALLED BY:
*
*-----------------------------------------------------------------------------------------------------------------
* REVISION HISTORY
*
* Date            By Who                 Reference                                   Reason
*
* 24.01.2013      RIYAS

* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - I TO I.VAR, SM TO @SM, = TO EQ, J TO J.VAR
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
******************************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION

    GOSUB INIT
    GOSUB BUILD.SELECT.STMT

RETURN

*----
INIT:
*----

    YFIRST.COND = 1
    OUT.SELECT = ''
RETURN


*-----------------
BUILD.SELECT.STMT:
*-----------------

    OUT.SELECT = "SELECT " : IN.FILE
    YCOUNT = DCOUNT(D.FIELDS, @FM)

    FOR I.VAR = 1 TO YCOUNT   ;** R22 Auto conversion - I TO I.VAR
        GOSUB BUILD.SELECT.CONDITION
    NEXT I.VAR                ;** R22 Auto conversion - I TO I.VAR
    CHANGE @SM TO ' ' IN OUT.SELECT
RETURN

*----------------------
BUILD.SELECT.CONDITION:
*----------------------

    IF YFIRST.COND EQ 1 THEN   ;** R22 Auto conversion - = TO EQ
        OUT.SELECT := " WITH "
        YFIRST.COND = 0
    END ELSE
        OUT.SELECT := " AND "
    END

    YVALUE = D.RANGE.AND.VALUE<I.VAR>          ;** R22 Auto conversion - I TO I.VAR
    YOPERATOR = D.LOGICAL.OPERANDS<I.VAR>      ;** R22 Auto conversion - I TO I.VAR

    OUT.SELECT := "("

    BEGIN CASE
        CASE YOPERATOR EQ "LK"         ;** R22 Auto conversion - = TO EQ
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ "UL"         ;** R22 Auto conversion - = TO EQ
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ "RG"         ;** R22 Auto conversion - = TO EQ
            YUBOUND = FIELD(YVALUE, @SM, 1)
            YLBOUND = FIELD(YVALUE, @SM, 2)
            OUT.SELECT := D.FIELDS<I.VAR> : " GE " : "'" : YUBOUND : "'"   ;** R22 Auto conversion - I TO I.VAR
            OUT.SELECT := " AND "
            OUT.SELECT := D.FIELDS<I.VAR> : " LE " : "'" : YLBOUND : "'"   ;** R22 Auto conversion - I TO I.VAR
        CASE YOPERATOR EQ "NR"           ;** R22 Auto conversion - = TO EQ
            YUBOUND = FIELD(YVALUE, @SM, 1)
            YLBOUND = FIELD(YVALUE, @SM, 2)
            OUT.SELECT := D.FIELDS<I.VAR> : " LT " : "'" : YUBOUND : "'"   ;** R22 Auto conversion - I TO I.VAR
            OUT.SELECT := " OR "
            OUT.SELECT := D.FIELDS<I.VAR> : " GT " : "'" : YLBOUND : "'"   ;** R22 Auto conversion - I TO I.VAR
        CASE YOPERATOR EQ 'NE'             ;** R22 Auto conversion - = TO EQ
            IF YVALUE[1,1] EQ "'" THEN     ;** R22 Auto conversion - = TO EQ
                YVALUE = TRIM(YVALUE,"'","A")
            END
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ 'EQ'            ;** R22 Auto conversion - = TO EQ
            IF YVALUE[1,1] EQ "'" THEN    ;** R22 Auto conversion - = TO EQ
                YVALUE = TRIM(YVALUE,"'","A")
            END
            GOSUB BUILD.SUB.SELECT.COND
        CASE 1
            OUT.SELECT := D.FIELDS<I.VAR> : " "    ;** R22 Auto conversion - I TO I.VAR
            OUT.SELECT := YOPERATOR : " "
            OUT.SELECT := "'" : YVALUE : "'"
    END CASE

    OUT.SELECT := ")"
RETURN

*---------------------
BUILD.SUB.SELECT.COND:
*---------------------

    VAL.COUNT = DCOUNT(YVALUE, @SM)
    FOR J.VAR = 1 TO VAL.COUNT           ;** R22 Auto conversion - J TO J.VAR
        TEMP.OPERATOR =  YOPERATOR
        BEGIN CASE
            CASE YOPERATOR EQ 'LK'      ;** R22 Auto conversion - = TO EQ
                TEMP.OPERATOR = 'LIKE'
            CASE YOPERATOR EQ 'UL'      ;** R22 Auto conversion - = TO EQ
                TEMP.OPERATOR = ' UNLIKE '
        END CASE
        OUT.SELECT := D.FIELDS<I.VAR> : " "   ;** R22 Auto conversion - I TO I.VAR
        OUT.SELECT := TEMP.OPERATOR : " "
        OUT.SELECT := "'" :YVALUE<1,1,J.VAR> : "'"     ;** R22 Auto conversion - J TO J.VAR
        IF J.VAR NE VAL.COUNT THEN                ;** R22 Auto conversion - J TO J.VAR
            BEGIN CASE
                CASE YOPERATOR EQ 'NE' OR YOPERATOR EQ 'UL'   ;** R22 Auto conversion - = TO EQ
                    OUT.SELECT := ' AND '
                CASE YOPERATOR EQ 'EQ' OR YOPERATOR EQ 'LK'   ;** R22 Auto conversion - = TO EQ
                    OUT.SELECT := ' OR '
            END CASE
        END
    NEXT J.VAR               ;** R22 Auto conversion - J TO J.VAR
RETURN
*--------------------------------------------------------------------------------
END
