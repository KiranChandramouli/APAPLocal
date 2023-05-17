SUBROUTINE REDO.E.CNV.BILL.TYPE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.BILL.TYPE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a converstion routine to ge the EB.LOOKUP value for BILL.COND
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  06Apr2011       Pradeep S            PACS00052995             Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS

RETURN

*========
PROCESS:
*=======

    Y.BILL.COND = O.DATA
    CHANGE @VM TO @FM IN Y.BILL.COND
    Y.CNT.VALUES = DCOUNT(Y.BILL.COND,@FM)

    VAR.VIRTUAL.TABLE = 'BILL.TYPE'

    Y.VALUES = Y.BILL.COND
    GOSUB GET.VALUES
    O.DATA = Y.BILL.VAL


RETURN


*=====================
GET.VALUES:
*======================

    VIRTUAL.TABLE.IDS = ''
    VIRTUAL.TABLE.VALUES = ''
    Y.BILL.VAL = ''

    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>      ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS

    CNT =1
    LOOP
    WHILE CNT LE Y.CNT.VALUES
        TABLE.IDS = ''
        TABLE.IDS = Y.VALUES<CNT>
        LOCATE TABLE.IDS IN VIRTUAL.TABLE.IDS SETTING POS THEN
            Y.BILL.VAL<1,-1> = VIRTUAL.TABLE.VALUES<POS>
        END
        CNT += 1
    REPEAT

RETURN

END
