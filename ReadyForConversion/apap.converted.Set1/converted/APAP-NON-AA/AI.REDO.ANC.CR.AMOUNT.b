SUBROUTINE AI.REDO.ANC.CR.AMOUNT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : AI.REDO.ANC.CR.AMOUNT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ANC routine to null the value if amount is 0
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------
PROCESS:
*********
    Y.CREDIT.AMT = System.getVariable('CURRENT.ARC.AMT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CREDIT.AMT = ""
    END
    IF Y.CREDIT.AMT EQ 0 THEN
        R.NEW(FT.CREDIT.AMOUNT) = ''
    END ELSE
        R.NEW(FT.CREDIT.AMOUNT) = Y.CREDIT.AMT
    END
RETURN
END
