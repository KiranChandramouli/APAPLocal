SUBROUTINE REDO.E.BUILD.TRANS.PERIOD(ENQ.DATA)
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.TRANS.PERIOD
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.BUILD.TRANS.PERIOD
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  30-10-2010       Prabhu N            ODR-2010-08-0031           Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
*---------------------------------------------------------------------------------------------------------
    GOSUB INITIALISE.GET.VALUES
    GOSUB PROCESS
RETURN

*----------------------------------------
INITIALISE.GET.VALUES:
*---------------------------------------
    DAYS = ''
    Y.BOOK.DATE.LEN = ''
    Y.FROM.DATE.VAL = ''
    Y.CURRENT.DAY = ''
    ST.RG.DATE=''
    END.RG.DATE=''
    END.TO.DATE=''
    START.FRM.DATE=''
    END.TO.DATE = TODAY
    LOCATE "START.DATE" IN ENQ.DATA<2,1> SETTING ST.DT.POS THEN
        ST.RG.DATE = ENQ.DATA<4,ST.DT.POS>
    END

    LOCATE "END.DATE" IN ENQ.DATA<2,2> SETTING END.DT.POS THEN
        END.RG.DATE = ENQ.DATA<4,END.DT.POS>
    END

RETURN
*----------------------------------------

*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------


*IF ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.STMT.ENT.PERIOD' THEN
    BEGIN CASE
        CASE ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.STMT.ENT.PERIOD' OR ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.LOAN.ENT.PERIOD'
            START.FRM.DATE = '1M'
            SIGN='-'
            GOSUB GET.CALL.DATE
            GOSUB FORM.ENQ.DATA

        CASE ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.PREVIOUS.TWO.MTH' OR ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.LOAN.PREVIOUS.TWO.MTH'
            START.FRM.DATE='2M'
            SIGN='-'
            GOSUB GET.CALL.DATE
            GOSUB FORM.ENQ.DATA

        CASE ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.PREVIOUS.THREE.MTH' OR ENQ.DATA<1,1> EQ 'AI.REDO.ENQ.LOAN.PREVIOUS.THREE.MTH'
            START.FRM.DATE='3M'
            SIGN='-'
            GOSUB GET.CALL.DATE
            GOSUB FORM.ENQ.DATA

        CASE ENQ.DATA<1,1> EQ 'AI.REDO.STMT.ENT.MYLIST'
            START.FRM.DATE = ST.RG.DATE
            END.TO.DATE  =END.RG.DATE
            GOSUB FORM.ENQ.DATA

        CASE ENQ.DATA<1,1> EQ 'AI.REDO.STMT.ENT.CREDIT.TRANS'
            START.FRM.DATE =ST.RG.DATE
            END.TO.DATE=END.RG.DATE
            GOSUB FORM.ENQ.DATA

        CASE ENQ.DATA<1,1> EQ 'AI.REDO.STMT.ENT.DEBIT.TRANS'
            START.FRM.DATE =ST.RG.DATE
            END.TO.DATE = END.RG.DATE
            GOSUB FORM.ENQ.DATA

        CASE OTHERWISE
            IF ST.RG.DATE AND END.RG.DATE THEN
                REGION=''
                START.DATE=ST.RG.DATE
                END.DATE=END.RG.DATE
                DAYS='C'
                CALL CDD(REGION,START.DATE,END.DATE,DAYS)
            END
            IF DAYS GT 180 THEN
                ENQ.ERROR = "EB-ENTER.MONTHS.PAERIOD"
            END
*GOSUB FORM.ENQ.DATA
    END CASE
RETURN

**************
GET.CALL.DATE:
****************
    CALL CALENDAR.DAY(END.TO.DATE,SIGN,START.FRM.DATE)
RETURN

*****************
FORM.ENQ.DATA:
**************
    ENQ.DATA<2,1> = "BOOKING.DATE"
    ENQ.DATA<3,1> = "RG"
    ENQ.DATA<4,1> = START.FRM.DATE:" ":END.TO.DATE
RETURN
END
