SUBROUTINE REDO.B.AZ.MIG.PERIOD.END.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUJITHA S
* Program Name : REDO.B.AZ.MIG.PERIOD.END.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_REDO.B.AZ.MIG.PERIOD.END.COMMON

    Y.DATE              = TODAY
    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    SEL.CMD = "SELECT ":FN.AZACCOUNT:" WITH ROLLOVER.DATE GT ":Y.LAST.WORKING.DATE:" AND ROLLOVER.DATE LE ":Y.DATE:" AND L.AZ.REF.NO LIKE AZ-..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CK.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN

END
