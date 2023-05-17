SUBROUTINE REDO.E.CNV.DATE.RANGE
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.DATE.RANGE
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.DAMAGED.CARD.REPORT
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   01-10-2010       DHAMU S          ODR-2010-03-0125 TDN3       Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------------------------------
********
PROCESS:
********

    FROM.DATE.VALUE = ""
    LOCATE "FROM.DATE" IN ENQ.SELECTION<2,1> SETTING Y.FROM.DATE.POS THEN
        FROM.DATE.VALUE = ENQ.SELECTION<4,Y.FROM.DATE.POS>
    END

    UNTIL.DATE.VALUE = ""
    LOCATE "UNTIL.DATE" IN ENQ.SELECTION<2,1> SETTING Y.UNTIL.DATE.POS THEN
        UNTIL.DATE.VALUE = ENQ.SELECTION<4,Y.UNTIL.DATE.POS>
    END

    IF FROM.DATE.VALUE NE '' AND UNTIL.DATE.VALUE NE '' THEN
        O.DATA = FROM.DATE.VALUE:"~":UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE NE '' AND UNTIL.DATE.VALUE EQ '' THEN
        UNTIL.DATE.VALUE = TODAY
        O.DATA = FROM.DATE.VALUE:"~":UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE EQ '' AND UNTIL.DATE.VALUE NE '' THEN
        FROM.DATE.VALUE = "-"
        O.DATA = FROM.DATE.VALUE:"~":UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE EQ "" AND UNTIL.DATE.VALUE EQ "" THEN
        FROM.DATE.VALUE = "-"
        UNTIL.DATE.VALUE = "-"
        O.DATA = FROM.DATE.VALUE:"~":UNTIL.DATE.VALUE
    END

RETURN

END
