* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRE.ARR.AA.OFS.SELECT
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
*
    $INSERT I_REDO.B.CRE.ARR.AA.OFS.COMMON

    LIST.PARAMETERS = '' ; ID.LIST = ''

    SELECT.STATEMENT = 'SELECT ':FN.REDO.CRE.ARR.AA.OFS.LIST
    NO.SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,ID.LIST,'',NO.SELECTED,SYSTEM.RETURN.CODE)

*     LIST.PARAMETERS<2> = 'F.REDO.CRE.ARR.AA.OFS.LIST'
*     LIST.PARAMETERS<3> = 'TRADE.CCY EQ "USD"'

    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

RETURN
END
