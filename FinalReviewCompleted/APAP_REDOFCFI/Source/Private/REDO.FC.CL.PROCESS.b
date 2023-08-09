<<<<<<< Updated upstream
* @ValidationCode : MjoxOTIwNTk0ODY5OkNwMTI1MjoxNjkwMjY2MzQzMTgxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:55:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
=======
* @ValidationCode : MjoxMjYyODQ3ODg3OkNwMTI1MjoxNjg1NTQzMzcxNjM1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 19:59:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
<<<<<<< Updated upstream
*           CALL REDO.FC.CL.REGISTER.AA
            APAP.AA.redoFcClRegisterAa() ;*R22 Manual Conversion
=======
            CALL REDO.FC.CL.REGISTER.AA
*APAP.AA.redoFcClRegisterAa() ;*R22 Manual Conversion
>>>>>>> Stashed changes
          
        CASE Y.OPTION EQ 'DESEMBOLSO'

            APAP.AA.redoFcClDisburstmentAa() ;*R22 Manual Conversion
        CASE Y.OPTION EQ 'MANTENIMIENTO'

            APAP.REDOFCFI.redoFcClVerifyMaint() ;*R22 Manual Conversion
           
        CASE Y.OPTION EQ 'PAGO'

            APAP.AA.redoFcClPaymentAa(PAY.AMOUNT, PAY.AA.ID) ;*R22 Manual Conversion
           

    END CASE

RETURN

END
