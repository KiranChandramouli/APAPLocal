SUBROUTINE REDO.B.ESM.STATUS.UPD.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.ESM.STATUS.UPD.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History:
*Development for Subroutine to perform the initialisation of the batch job
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 09 AUG 2011    Prabhu N      PACS00100804      Load routine for the development REDO.B.ESM.STATUS.UPD
*-------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_REDO.B.ESM.STATUS.UPD.COMMON

    GOSUB INIT
    GOSUB OPENFILES
RETURN
*----
INIT:
*----

    FN.EB.SECURE.MESSAGE='F.EB.SECURE.MESSAGE'
    F.EB.SECURE.MESSAGE=''

    FN.REDO.T.MSG.DET='F.REDO.T.MSG.DET'
    F.REDO.T.MSG.DET=''

RETURN
*--------
OPENFILES:
*--------
    CALL OPF(FN.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE)
    CALL OPF(FN.REDO.T.MSG.DET,F.REDO.T.MSG.DET)

RETURN
END
