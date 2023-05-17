SUBROUTINE REDO.CHQ.PRNT.VERSIONS.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHQ.PRNT.VERSIONS.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CHQ.PRNT.VERSIONS.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.CHQ.PRNT.VERSIONS, the routine checks if the duplicate value entered in the
*                    VERSIONS field
*Linked With       : Template - REDO.CHQ.PRNT.VERSIONS
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.CHQ.PRNT.VERSIONS           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010         Nava V.              PACS00239746                Initial Creation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CHQ.PRNT.VERSIONS
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = PRINT.CHQ.LIST.VERSIONS
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
