SUBROUTINE REDO.V.WAIVE.COMMISION
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.WAIVE.COMMISION
*--------------------------------------------------------------------------------------------------------
*Description  : This routine is used to waive the commision in case account is own account
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 Oct 2010     SWAMINATHAN          ODR-2009-12-0290         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System

*--------------------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------

PROCESS:
*********

    Y.OWN.ACCOUNT=System.getVariable("CURRENT.USER.CAT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.OWN.ACCOUNT = ""
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        IF Y.OWN.ACCOUNT EQ 'YES' THEN
            R.NEW(FT.COMMISSION.CODE) = 'WAIVE'
        END
    END
    IF APPLICATION EQ 'STANDING.ORDER' THEN
        IF Y.OWN.ACCOUNT EQ 'YES' THEN
            R.NEW(STO.COMMISSION.CODE) = 'WAIVE'
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------
END
