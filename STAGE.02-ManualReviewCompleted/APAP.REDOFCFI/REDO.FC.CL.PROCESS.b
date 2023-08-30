* @ValidationCode : MjotMTk5ODEyNzg0ODpDcDEyNTI6MTY4MDYwMzIzNjE4NjpJVFNTOi0xOi0xOi0yMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:43:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -21
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
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
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
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
