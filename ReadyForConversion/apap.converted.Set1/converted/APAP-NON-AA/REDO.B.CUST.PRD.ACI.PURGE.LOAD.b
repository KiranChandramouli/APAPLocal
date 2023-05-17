SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.LOAD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.CUST.PRD.ACI.PURGE.LOAD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON

    FN.REDO.BATCH.JOB.LIST.FILE = 'F.REDO.BATCH.JOB.LIST.FILE'
    F.REDO.BATCH.JOB.LIST.FILE = ''
    CALL OPF(FN.REDO.BATCH.JOB.LIST.FILE, F.REDO.BATCH.JOB.LIST.FILE)

RETURN
END
