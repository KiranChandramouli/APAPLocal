* @ValidationCode : MjotODAzNjQ3MDY6Q3AxMjUyOjE2ODI1OTgwMTEzODg6c2FtYXI6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
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
*APAP.REDOFCFI.REDO.FC.CL.ACCOUNTING(Y.ACTION)
    APAP.REDOFCFI.redoFcClAccounting(action)   ;* MANUAL R22 CODE CONVERSION
RETURN
*---------------------------------------------------------------------------
END
