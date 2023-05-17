*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------

******************************************************************************
  SUBROUTINE REDO.FC.CL.PROCESS(Y.OPTION)
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
* ----------------------------------------------------------------------------
* Subroutine Type :  SUBROUTINE
* Attached to     :  FC PROCESS
* Attached as     :
* Primary Purpose :  Handler for managing Collateral Balances
*
*
* Incoming        :  Y.OPTION (Type of process: CREACION, MANTENIMIENTO,
*                    DESEMBOLSO, PAGO)
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : junio 11 2011
*
* Development by  : lpazminodiaz@temenos.com
* Date            : 17/08/2011
* Purpose         : Minor fixes (delete CHECK.PRELIM.CONDITIONS)
******************************************************************************

******************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
******************************************************************************

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* =========
INITIALISE:
* =========
  RETURN

* =========
OPEN.FILES:
* =========
  RETURN

* ======
PROCESS:
* ======
  BEGIN CASE
  CASE Y.OPTION EQ 'CREACION'
    CALL REDO.FC.CL.REGISTER.AA

  CASE Y.OPTION EQ 'DESEMBOLSO'
    CALL REDO.FC.CL.DISBURSTMENT.AA

  CASE Y.OPTION EQ 'MANTENIMIENTO'
    CALL REDO.FC.CL.VERIFY.MAINT

  CASE Y.OPTION EQ 'PAGO'
    CALL REDO.FC.CL.PAYMENT.AA

  END CASE

  RETURN

END
