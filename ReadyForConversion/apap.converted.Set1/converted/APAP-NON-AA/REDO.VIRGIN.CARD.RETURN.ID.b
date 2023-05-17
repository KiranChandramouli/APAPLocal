SUBROUTINE REDO.VIRGIN.CARD.RETURN.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to to fetch next sequence no from F.LOCKING
*Linked With  : REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 21-Jan-2010    Kavitha S             ODR-2010-03-0400        Code change as per CR
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    IF NOT(RUNNING.UNDER.BATCH) THEN
        IF GTSACTIVE THEN
            IF OFS$OPERATION EQ 'BUILD' THEN
                GOSUB PROCESS.PARA
                RETURN
            END
        END ELSE
            GOSUB PROCESS.PARA
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section
    E = ''

    IF V$FUNCTION EQ 'I' THEN
        ID.NEW = ID.COMPANY:"-":TODAY
    END
RETURN
*-------------------------------------------------------------------------
END
