SUBROUTINE REDO.B.REINV.SYNC.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUJITHA S
* Program Name : REDO.B.REINV.SYNC.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 16-06-2010      SUJITHA.S   ODR-2009-10-0332  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_REDO.B.REINV.SYNC.COMMON

*This selection part is handled in main run routine. This batch is common for both type of deposits
* SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZACCOUNT:" WITH L.TYPE.INT.PAY EQ Reinvested"
    SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZACCOUNT
    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,AZ.ERR)
    CALL BATCH.BUILD.LIST('', SEL.AZ.ACCOUNT.LIST)

RETURN
END
