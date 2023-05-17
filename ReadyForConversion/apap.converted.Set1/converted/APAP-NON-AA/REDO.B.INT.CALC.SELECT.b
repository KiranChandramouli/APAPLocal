SUBROUTINE REDO.B.INT.CALC.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.INT.CALC.SELECT
*-------------------------------------------------------------------------
* Description: This routine is a select routine used to Select the records
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 22-11-10          ODR-2010-09-0251                 Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT.DEBIT.INT
    $INSERT I_F.GROUP.DEBIT.INT
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.INTEREST.REVERSE
    $INSERT I_REDO.B.INT.CALC.COMMON

    GOSUB PROCESS
RETURN

PROCESS:

*    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.TRANS.INT EQ Y "
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
    SEL.LIST = R.REDO.W.ACCOUNT.UPDATE
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
