SUBROUTINE REDO.B.CREDIT.NOSTRO.ACCT.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CREDIT.NOSTRO.ACCT.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CREDIT.NOSTRO.ACCT

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_REDO.B.CREDIT.NOSTRO.ACCT.COMMON


    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=''
    ERR=''
    SEL.CMD="SELECT ":FN.REDO.MANAGER.CHQ.DETAILS:" WITH ISSUE.DATE EQ ":LAST.WORK.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
