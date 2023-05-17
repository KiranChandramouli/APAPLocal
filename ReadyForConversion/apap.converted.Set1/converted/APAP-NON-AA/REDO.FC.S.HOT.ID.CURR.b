SUBROUTINE REDO.FC.S.HOT.ID.CURR
*
* ====================================================================================
*
*

* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:
* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo(jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : Oct 2011

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======



    CALL System.setVariable("CURRENT.Y.CURRENCY",Y.CURRENCY)

RETURN
*
* =========
OPEN.FILES:
* =========
*

RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1



    Y.CURRENCY= COMI



RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*


*
RETURN
*

END
