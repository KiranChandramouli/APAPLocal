SUBROUTINE REDO.B.REINV.BAL.UPDATE.SELECT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.BAL.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Description: This routine is a select routine for REDO.B.REINV.BAL.UPDATE
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 05-Jul-2011    H GANESH       PACS00072695_N.11  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.REINV.BAL.UPDATE.COMMON


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH L.TYPE.INT.PAY EQ Reinvested'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,AZ.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)

RETURN
END
