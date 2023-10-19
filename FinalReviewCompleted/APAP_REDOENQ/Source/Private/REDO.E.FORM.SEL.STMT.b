* @ValidationCode : MjoxOTUwMDI0MjE4OkNwMTI1MjoxNjg2Njc1NTY4OTg2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:29:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
******************************************************************************************************************
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.FORM.SEL.STMT(IN.FILE, IN.FIXED, IN.SORT, OUT.SELECT)
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
* 08.12.31        N. Satheesh Kumar
* 09.06.2023       Santosh             R22 Manual Conversion        Added package
******************************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB BUILD.SELECT.STMT

RETURN

*----
INIT:
*----

    YFIRST.COND = 1
    YFIXED = TRIM(IN.FIXED, '', "B")
    YSORT = TRIM(IN.SORT, '', "B")
    OUT.SELECT = ''
RETURN

*----------
OPEN.FILES:
*----------

    FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
    CALL OPF(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)
RETURN

*-----------------
BUILD.SELECT.STMT:
*-----------------

    CALL CACHE.READ(FN.STANDARD.SELECTION, DATA.FILE.NAME, R.SS, YERR)

    IF YERR THEN
        ENQ.ERROR<-1> = YERR
        RETURN
    END

    YUSR.FIELD.NAME = R.SS<SSL.USR.FIELD.NAME>
    YUSR.TYPE = R.SS<SSL.USR.TYPE>
    OUT.SELECT = "SELECT " : IN.FILE
    YCOUNT = DCOUNT(D.FIELDS, @FM)

    FOR I.VAR = 1 TO YCOUNT
        LOCATE D.FIELDS<I.VAR> IN YUSR.FIELD.NAME<1, 1> SETTING YPOS ELSE
            CONTINUE
        END

        IF YUSR.TYPE<1, YPOS> EQ "R" THEN
            CONTINUE
        END

        GOSUB BUILD.SELECT.CONDITION
    NEXT I.VAR

    YCOUNT = DCOUNT(YFIXED, @FM)
    FOR I.VAR = 1 TO YCOUNT
        IF YFIRST.COND EQ 1 THEN
            OUT.SELECT := " WITH "
            YFIRST.COND = 0
        END ELSE
            OUT.SELECT := " AND "
        END

        OUT.SELECT := YFIXED<I.VAR>
    NEXT I.VAR

    YCOUNT = DCOUNT(YSORT, @FM)
    FOR I.VAR = 1 TO YCOUNT
        OUT.SELECT := " " : YSORT<I.VAR>
    NEXT I.VAR
    CHANGE @SM TO ' ' IN OUT.SELECT
RETURN

*----------------------
BUILD.SELECT.CONDITION:
*----------------------

    IF YFIRST.COND EQ 1 THEN
        OUT.SELECT := " WITH "
        YFIRST.COND = 0
    END ELSE
        OUT.SELECT := " AND "
    END

    YVALUE = D.RANGE.AND.VALUE<I.VAR>
    YOPERATOR = OPERAND.LIST<D.LOGICAL.OPERANDS<I.VAR>>

    OUT.SELECT := "("

    BEGIN CASE
        CASE YOPERATOR EQ "LK"
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ "UL"
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ "RG"
            YUBOUND = FIELD(YVALUE, @SM, 1)
            YLBOUND = FIELD(YVALUE, @SM, 2)
            OUT.SELECT := D.FIELDS<I.VAR> : " GE " : "'" : YUBOUND : "'"
            OUT.SELECT := " AND "
            OUT.SELECT := D.FIELDS<I.VAR> : " LE " : "'" : YLBOUND : "'"
        CASE YOPERATOR EQ "NR"
            YUBOUND = FIELD(YVALUE, @SM, 1)
            YLBOUND = FIELD(YVALUE, @SM, 2)
            OUT.SELECT := D.FIELDS<I.VAR> : " LT " : "'" : YUBOUND : "'"
            OUT.SELECT := " OR "
            OUT.SELECT := D.FIELDS<I.VAR> : " GT " : "'" : YLBOUND : "'"
        CASE YOPERATOR EQ 'NE'
            IF YVALUE[1,1] EQ "'" THEN
                YVALUE = TRIM(YVALUE,"'","A")
            END
            GOSUB BUILD.SUB.SELECT.COND
        CASE YOPERATOR EQ 'EQ'
            IF YVALUE[1,1] EQ "'" THEN
                YVALUE = TRIM(YVALUE,"'","A")
            END
            GOSUB BUILD.SUB.SELECT.COND
        CASE 1
            OUT.SELECT := D.FIELDS<I.VAR> : " "
            OUT.SELECT := YOPERATOR : " "
            OUT.SELECT := "'" : YVALUE : "'"
    END CASE

    OUT.SELECT := ")"
RETURN

*---------------------
BUILD.SUB.SELECT.COND:
*---------------------

    VAL.COUNT = DCOUNT(YVALUE, @SM)
    FOR J.VAR = 1 TO VAL.COUNT
        TEMP.OPERATOR =  YOPERATOR
        BEGIN CASE
            CASE YOPERATOR EQ 'LK'
                TEMP.OPERATOR = 'LIKE'
            CASE YOPERATOR EQ 'UL'
                TEMP.OPERATOR = ' UNLIKE '
        END CASE
        OUT.SELECT := D.FIELDS<I.VAR> : " "
        OUT.SELECT := TEMP.OPERATOR : " "
        OUT.SELECT := "'" :YVALUE<1,1,J.VAR> : "'"
        IF J.VAR NE VAL.COUNT THEN
            BEGIN CASE
                CASE YOPERATOR EQ 'NE' OR YOPERATOR EQ 'UL'
                    OUT.SELECT := ' AND '
                CASE YOPERATOR EQ 'EQ' OR YOPERATOR EQ 'LK'
                    OUT.SELECT := ' OR '
            END CASE
        END
    NEXT J.VAR
RETURN
*--------------------------------------------------------------------------------
END
