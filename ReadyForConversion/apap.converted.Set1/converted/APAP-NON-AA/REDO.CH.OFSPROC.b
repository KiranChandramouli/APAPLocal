SUBROUTINE REDO.CH.OFSPROC(OFS.MSG,OFS.SRC)
**
* Subroutine Type :
* Attached to     : Subroutine REDO.CH.CHGPROFILE
* Attached as     :
* Primary Purpose : Process the first OFS message to change the UIBEHAVIOUR activity.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 05/07/12 - First Version.
*            ODR Reference: ODR-2010-06-0155.
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS

RETURN

********
PROCESS:
********

    TXN.COMM = ''
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC,OFS.MSG,RESP.OFS.MSG,TXN.COMM)

RETURN

END
