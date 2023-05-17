SUBROUTINE REDO.APAP.B.INVST.PROVISIONING.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.INVST.PROVISIONING.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.INVST.PROVISIONING.SELECT is the select routine to make a select on
*                    the REDO.H.CUSTOMER.PROVISION file
*Linked With       : Batch BNK/REDO.B.INVST.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 27 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 01.04.2011           Pradeep S                   PACS00055823                    Fix
* 26.05.2011           RIYAS                       PACS00061656                    Fix
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.APAP.B.INVST.PROVISIONING.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    SEL.LIST = ''
    IF Y.NEXT.RUN.DATE LE TODAY THEN
        SEL.CMD = "SELECT ":FN.REDO.H.CUSTOMER.PROVISION
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    END

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
*--------------------------------------------------------------------------------------------------------
END
