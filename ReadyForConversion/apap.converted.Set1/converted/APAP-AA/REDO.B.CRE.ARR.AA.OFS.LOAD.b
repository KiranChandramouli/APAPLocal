* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRE.ARR.AA.OFS.LOAD
*-----------------------------------------------------------------------------
* Fabrica de Credito
* This SERVICE has to check if the AA that was queued by REDO.CREATE.ARRANGEMENT
* is created OK or NOT
*
*        AUTHOR                   DATE
*-----------------------------------------------------------------------------
* hpasquel@temenos.com         2011-01-11
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CRE.ARR.AA.OFS.COMMON
*-----------------------------------------------------------------------------
* Open files to be used in the XX routine as well as standard variables

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.REDO.CRE.ARR.AA.OFS.LIST = 'F.REDO.CRE.ARR.AA.OFS.LIST'
    F.REDO.CRE.ARR.AA.OFS.LIST = ''
    CALL OPF(FN.REDO.CRE.ARR.AA.OFS.LIST,F.REDO.CRE.ARR.AA.OFS.LIST)

    FN.OFS.RESPONSE.QUEUE = 'F.OFS.RESPONSE.QUEUE'
    F.OFS.RESPONSE.QUEUE = ''
    CALL OPF(FN.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE)

    FN.OFS.MESSAGE.QUEUE = 'F.OFS.MESSAGE.QUEUE'
    F.OFS.MESSAGE.QUEUE = ''
    CALL OPF(FN.OFS.MESSAGE.QUEUE,F.OFS.MESSAGE.QUEUE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
END
