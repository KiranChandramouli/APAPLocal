SUBROUTINE REDO.APAP.PARAM.PURGE.LOAD
*******************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Temenos Application Management
* Program Name : REDO.NOF.TRANS.DET.EACH.TYPE
*--------------------------------------------------------------------------------
*--------------------------------------------------------------------------------
*Description :This routine is a load routine used to load the variables
************************************************************************************
* Linked with:
* In parameter :
* out parameter : None
*-----------------------------------------------------------------------------
* MODIFICATION HISTORY
*-----------------------------------------------------------------------------
*   DATE         WHO                    ODR                   DESCRIPTION
*============    ==============         ================      ================
*14-4-2011      janani                 ODR-2011-03-0113       Initial Creation
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.COMMON
    $INSERT I_F.APAP.REDO.PURGE.PARAM
    GOSUB PROCESS

RETURN

********
PROCESS:
********

    FN.APPLICATION = ''
    F.APPLICATION = ''

    Y.APP = ''
    Y.APP.LOC = ''

    FN.APAP.REDO.PURGE.PARAM = 'F.APAP.REDO.PURGE.PARAM'
    F.APAP.REDO.PURGE.PARAM = ''
    R.APAP.REDO.PURGE.PARAM = ''
    CALL OPF(FN.APAP.REDO.PURGE.PARAM,F.APAP.REDO.PURGE.PARAM)

    Y.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.APAP.REDO.PURGE.PARAM,Y.PARAM.ID,R.APAP.REDO.PURGE.PARAM,Y.PARAM.ERR)
    Y.DATE = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.PURGE.TILL>
    Y.DATE.CNT = DCOUNT(Y.DATE,@VM)
    Y.DATE.INIT = 1

RETURN
************************
END
*-----------End of Program --------------------------------
