* @ValidationCode : MjoxMzQzMjMwMDI2OkNwMTI1MjoxNzA0NDQxNzExMzE4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:31:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
    $USING EB.Service
    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    SEL.CMD="SSELECT ":FN.FUNDS.TRANSFER:" WITH RECORD.STATUS EQ IHLD AND INWARD.PAY.TYPE LIKE STO... AND DEBIT.VALUE.DATE EQ ":TODAY
    CALL EB.READLIST(SEL.CMD,PROCESS.LIST,'',NOR,ERR)
*    CALL BATCH.BUILD.LIST('',PROCESS.LIST)
    EB.Service.BatchBuildList('',PROCESS.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
*---------------------------------------------------------------------------------------------------------
END
