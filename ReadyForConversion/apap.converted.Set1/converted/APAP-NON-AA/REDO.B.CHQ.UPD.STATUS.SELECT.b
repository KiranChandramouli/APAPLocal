SUBROUTINE REDO.B.CHQ.UPD.STATUS.SELECT
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHQ.UPD.STATUS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : Multi threaded Select routine used to select the records

*In  Parameter     :
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S              PACS00146454             Initial Creation
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CHQ.UPD.STATUS.COMMON

MAIN:

    SEL.CMD = 'SELECT ':FN.REDO.LOAN.CHQ.RETURN
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
