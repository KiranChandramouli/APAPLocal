******************************************************************************
SUBROUTINE REDO.FC.ARRANGEMENT.AUTH
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
* ----------------------------------------------------------------------------
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : CALL the REDO.FC.CL.PROCCES TO CREACTE A RECORD IN REDO.FC.CL.BALANCE
* Incoming        : NA
* Outgoing        : NA
*
* ----------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Junio 01 2011
*

******************************************************************************

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE


******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

* =========
INITIALISE:
* =========
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1


RETURN

* =========
OPEN.FILES:
* =========

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================

RETURN

* ======
PROCESS:
* ======

    CALL REDO.FC.CL.PROCESS("CREACION")

RETURN

END
