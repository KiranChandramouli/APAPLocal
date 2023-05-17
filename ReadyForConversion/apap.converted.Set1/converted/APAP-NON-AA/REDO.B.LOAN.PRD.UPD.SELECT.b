SUBROUTINE REDO.B.LOAN.PRD.UPD.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SHANKAR RAJU
* Program Name : REDO.B.LOAN.PRD.UPD.SELECT
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.CUSTOMER.LIST
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - ODR-2009-10-0535
*Development for Subroutine to perform the selection of the batch job
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LOAN.PRD.UPD.COMMON

    GOSUB INIT
    GOSUB SEL.REC

RETURN
*----
INIT:
*----
    SEL.CUSTOMER.CMD="SELECT ":FN.CUST.PRD.LIST:" WITH PRD.STATUS EQ 'ACTIVE' AND WITH TYPE.OF.CUST EQ 'LOAN'"
    SEL.CUSTOMER.LIST=''
    NO.OF.REC=''
RETURN
*-------
SEL.REC:
*-------
    CALL EB.READLIST(SEL.CUSTOMER.CMD,SEL.CUSTOMER.LIST,'',NO.OF.REC,AZ.ERR)
    CALL BATCH.BUILD.LIST('', SEL.CUSTOMER.LIST)
RETURN
END
