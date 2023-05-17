$PACKAGE APAP.TAM
SUBROUTINE REDO.B.INT.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.INT.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Description: This is the Select routine in batch to update the interest rate in arrangement
* as per the changes in rate of AZ.ACCOUNT OR ACI OR GCI
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE              WHO                      REFERENCE                 DESCRIPTION
*  15.11.2009 H GANESH & S SUDHARSANAN    ODR-2009-10-0795           INITIAL CREATION
*  13.05.2011    H GANESH            PACS00032743 & PACS00055013     Modified as per issue
*
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INT.UPDATE.COMMON


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
*Y.ID='SYSTEM'
*CALL F.READ(FN.REDO.T.DEP.COLLATERAL,Y.ID,R.REDO.T.DEP.COLLATERAL,F.REDO.T.DEP.COLLATERAL,COLL.ERR)
*Y.ARRANGEMENT.IDS=R.REDO.T.DEP.COLLATERAL

    Y.ARRANGEMENT.IDS = ''
    SEL.CMD = 'SELECT ':FN.REDO.T.DEP.COLLATERAL
    CALL EB.READLIST(SEL.CMD,Y.ARRANGEMENT.IDS,'',SEL.NOR,SEL.RET)
    IF Y.ARRANGEMENT.IDS THEN
        CALL BATCH.BUILD.LIST('',Y.ARRANGEMENT.IDS)

        RETURN
    END
