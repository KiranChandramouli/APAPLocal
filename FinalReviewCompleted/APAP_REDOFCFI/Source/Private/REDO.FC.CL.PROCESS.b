* @ValidationCode : MjoxNzg4Njk1NTMwOkNwMTI1MjoxNjg1MTA2MDc3NDg4OklUU1M6LTE6LTE6LTI2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 18:31:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -26
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

******************************************************************************
$PACKAGE APAP.REDOFCFI
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
* 04-APRIL-2023      Harsha                R22 Manual Conversion - call routine format modified

*------------------------------------------------------------------------
******************************************************************************

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.AA
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
*CALL APAP.AA.redoFcClRegisterAa() ;*R22 Manual Conversion
          
        CASE Y.OPTION EQ 'DESEMBOLSO'

            CALL APAP.AA.redoFcClDisburstmentAa() ;*R22 Manual Conversion
        CASE Y.OPTION EQ 'MANTENIMIENTO'

            CALL APAP.REDOFCFI.redoFcClVerifyMaint() ;*R22 Manual Conversion
           
        CASE Y.OPTION EQ 'PAGO'

            CALL APAP.AA.redoFcClPaymentAa() ;*R22 Manual Conversion
           

    END CASE

RETURN

END
