SUBROUTINE REDO.B.NON.CONFIRM.PAY.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.NON.CONFIRM.PAY

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.NON.CONFIRM.PAY.COMMON

    FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM=''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS=''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)

    Y.UCSP.VALIDITY = R.CHQ.PARAM<ADMIN.CHQ.PARAM.UCSP.VALIDITY>

    LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    F.B.DATE="-":Y.UCSP.VALIDITY:"W"
    CALL CDT('',LAST.WORK.DATE,F.B.DATE)
    BEFORE.X.DAYS =LAST.WORK.DATE
RETURN
END
