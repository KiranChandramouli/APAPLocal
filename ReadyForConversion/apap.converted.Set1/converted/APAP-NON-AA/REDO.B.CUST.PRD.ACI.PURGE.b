SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE(Y.ACCT.NO)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.B.CUST.PRD.ACI.PURGE
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description : This batch routine is used to purge the table REDO.BATCH.JOB.LIST.FILE
* Linked with: N/A
* In parameter : None
* out parameter : None

*-----------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON

    GOSUB PROCESS
RETURN
*
*-------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    CALL F.DELETE(FN.REDO.BATCH.JOB.LIST.FILE,Y.ACCT.NO)
*-------------------------------------------------------------------------
END
