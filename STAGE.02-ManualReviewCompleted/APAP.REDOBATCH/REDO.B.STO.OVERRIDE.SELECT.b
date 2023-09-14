* @ValidationCode : MjotODk5OTg3MzA0OkNwMTI1MjoxNjgxMzYzNDA3NDgzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:53:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STO.OVERRIDE.SELECT
*--------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the select routine of the batch job REDO.B.STO.OVERRIDE
* This routine select the FT records in IHLD condition under the certain condition falls.
* -------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : FT.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference                          Description
* 24-AUG-2011   Sudharsanan   TAM-ODR-2009-10-0331(PACS0054326)   Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.B.STO.OVERRIDE.COMMON
    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    SEL.CMD="SSELECT ":FN.FUNDS.TRANSFER:" WITH RECORD.STATUS EQ IHLD AND INWARD.PAY.TYPE LIKE STO... AND DEBIT.VALUE.DATE EQ ":TODAY
    CALL EB.READLIST(SEL.CMD,PROCESS.LIST,'',NOR,ERR)
    CALL BATCH.BUILD.LIST('',PROCESS.LIST)
RETURN
*---------------------------------------------------------------------------------------------------------
END
