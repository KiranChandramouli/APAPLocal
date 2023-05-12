* @ValidationCode : MjoxMjMxMTM3MjQ0OkNwMTI1MjoxNjgzODA4NjQ2NjcxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 18:07:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.MON.E.CUSTID

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used as conversion routine in Enquiries. Internally reuse routine REDO.RAD.MON.CUSTID.OPER
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 22/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       Call Routine Format Modified
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    COMI.BACKUP = COMI
    COMI = O.DATA
*CALL APAP.TAM.REDO.RAD.MON.CUSTID.OPER    ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.redoRadMonCustidOper();*R22 MANUAL CODE CONVERSION
    O.DATA = COMI
    COMI = COMI.BACKUP


RETURN
*-----------------------------------------------------------------------------------

END
