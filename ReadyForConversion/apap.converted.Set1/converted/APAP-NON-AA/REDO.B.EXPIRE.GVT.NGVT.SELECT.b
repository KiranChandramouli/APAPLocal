SUBROUTINE REDO.B.EXPIRE.GVT.NGVT.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.EXPIRE.GVT.NGVT

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.EXPIRE.GVT.NGVT.COMMON

    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=''
    ERR=''

    SEL.CMD="SELECT ":FN.REDO.ADMIN.CHQ.DETAILS:" WITH (CHEQUE.INT.ACCT EQ ":NON.GVMNT.ACCT:" OR CHEQUE.INT.ACCT EQ ":GVMNT.ACCT:") AND ISSUE.DATE LT ":BEFORE.X.MNTHS:" AND STATUS EQ ISSUED"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
