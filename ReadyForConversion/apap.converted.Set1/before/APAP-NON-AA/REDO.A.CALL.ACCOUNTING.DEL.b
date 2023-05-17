  SUBROUTINE REDO.A.CALL.ACCOUNTING.DEL
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
*
* Subroutine Type : SUBROUTINE
* Attached to     : COLLATERAL VERSIONS FOR CREATION
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*
* Error Variables:
*------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : MG- TAM Latin America
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
*
  Y.ACTION = 'CANCEL'
*
  CALL REDO.FC.CL.ACCOUNTING(Y.ACTION)
*
  RETURN
*---------------------------------------------------------------------------
END
