SUBROUTINE REDO.B.STO.OVERRIDE.LOAD
*--------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the load routine of the batch job REDO.B.STO.OVERRIDE
* This routine opens the necessary files and read the parameter table.
* -------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference                          Description
* 24-AUG-2011   Sudharsanan   TAM-ODR-2009-10-0331(PACS0054326)   Initial Creation
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.STO.OVERRIDE.PARAM
    $INSERT I_REDO.B.STO.OVERRIDE.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*-----------
OPEN.FILES:
*-----------
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.STO.OVERRIDE.PARAM = 'F.REDO.STO.OVERRIDE.PARAM'

RETURN
*----------
PROCESS:
*----------
    STO.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM,STO.ERR)
    Y.MSG = R.STO.OVERRIDE.PARAM<STO.OVE.MESSAGE>
    CHANGE @SM TO @FM IN Y.MSG
    CHANGE @VM TO @FM IN Y.MSG
RETURN
END
