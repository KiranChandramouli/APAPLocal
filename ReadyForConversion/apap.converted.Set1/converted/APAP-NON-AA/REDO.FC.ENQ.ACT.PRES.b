SUBROUTINE REDO.FC.ENQ.ACT.PRES
* ============================================================================
*
* Subroutine Type : Routine
* Attached to     : REDO.FC.ACT.PRES
* Attached as     : Conversion routine attach to V.ARRANGEMENT field in
*                   RCA.PRODUCT.CATALOG-PRODUCTS enquiry
* Primary Purpose : Put de Description of the product in O.DATA to enquiry
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 24 2011

* Modified by     : Luis Pazmino
* Date            : Sept 19 2011
* Notes           : Code Review (Error Handling for F.READ)
* ============================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.REDO.FC.ACT.PRES
*************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* =========
INITIALISE:
* =========
    FN.REDO.FC.ACT.PRES = 'F.REDO.FC.ACT.PRES'
    F.REDO.FC.ACT.PRES  = ''

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.REDO.FC.ACT.PRES,F.REDO.FC.ACT.PRES)

RETURN

* ======
PROCESS:
* ======
    CALL F.READ(FN.REDO.FC.ACT.PRES, O.DATA, R.REDO.FC.ACT.PRES, F.REDO.FC.ACT.PRES, Y.ERR.ACT.PRES)
    IF NOT(Y.ERR.ACT.PRES) THEN
        Y.DESC.ID = R.REDO.FC.ACT.PRES<REDO.FC.ACT.DESC.PRODUCT>
        O.DATA = Y.DESC.ID:" I F3"
    END ELSE
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.ACT.PRES
        CALL STORE.END.ERROR
    END

RETURN

END
