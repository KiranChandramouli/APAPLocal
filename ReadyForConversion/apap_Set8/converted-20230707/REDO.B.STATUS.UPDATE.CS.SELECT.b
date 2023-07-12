SUBROUTINE REDO.B.STATUS.UPDATE.CS.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*--------------------------------------------------------------------------------
*Development for Subroutine to perform the selection of the batch job
* Revision History:
*------------------
*   20/10/2016        V.P.Ashokkumar                      R15 Upgrade Changes - Insert file name.
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STATUS.UPDATE.CS.COMMON

    GOSUB SEL.REC
RETURN

*-------
SEL.REC:
*-------
    SEL.CUST.CMD = ''; SEL.CUST.LIST=''; NO.OF.REC=''; SCUST.ERR = ''
    SEL.CUST.CMD="SELECT ":FN.CUSTOMER:" WITH CUSTOMER.STATUS EQ 1 AND L.CU.TARJ.CR EQ 'YES'"
    CALL EB.READLIST(SEL.CUST.CMD,SEL.CUST.LIST,'',NO.OF.REC,SCUST.ERR)
    CALL BATCH.BUILD.LIST('',SEL.CUST.LIST)
RETURN
END
