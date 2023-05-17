SUBROUTINE REDO.VISA.GEN.CHGBCK.OUT.SELECT
*********************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.GEN.CHGBCK.OUT.SELECT
***********************************************************************************
*Description: This routine is to select the set of outgoing CHARGEBACK records
*              which are ready to send as outgoing file
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON


    GOSUB PROCESS

RETURN

*******
PROCESS:
********

    SEL.CMD = "SELECT ":FN.REDO.VISA.CHGBCK.LOG
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.SEL,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
