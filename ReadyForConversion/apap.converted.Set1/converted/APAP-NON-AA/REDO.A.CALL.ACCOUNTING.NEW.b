SUBROUTINE REDO.A.CALL.ACCOUNTING.NEW
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : SUBROUTINE
* Attached to     : COLLATERALS VERSIONS FOR CREATION
* Attached as     : ROUTINE
* Primary Purpose :* Incoming:
* ---------
* Outgoing:
* ---------
*
*
* Error Variables:
*------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mg - TAM Latin America
* Date            : Calculate the next date from VALUATION.DUE.DATE
*
*------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL


    GOSUB PROCESS

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------
PROCESS:
*======
* CALL TO EB.ACCOUNTING ROUTINE

    Y.ACTION = 'NEW'
    CALL REDO.FC.CL.ACCOUNTING(Y.ACTION)

RETURN
*---------------------------------------------------------------------------
END
