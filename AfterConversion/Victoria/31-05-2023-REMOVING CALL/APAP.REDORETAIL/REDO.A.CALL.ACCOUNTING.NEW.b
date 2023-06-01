* @ValidationCode : MjoxNjY3NzQ3NzE2OkNwMTI1MjoxNjg1NTM1ODc2NjU1OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:54:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
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
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED

*------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $USING APAP.REDOFCFI


    GOSUB PROCESS

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------
PROCESS:
*======
* CALL TO EB.ACCOUNTING ROUTINE

    Y.ACTION = 'NEW'
*CALL APAP.REDOFCFI.REDO.FC.CL.ACCOUNTING(Y.ACTION)
    APAP.REDOFCFI.redoFcClAccounting(action)   ;* MANUAL R22 CODE CONVERSION
RETURN
*---------------------------------------------------------------------------
END
