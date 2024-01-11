* @ValidationCode : MjotOTY2NjU3OTg2OkNwMTI1MjoxNzA0MzY1MTk4NjY1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:16:38
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
SUBROUTINE REDO.B.LY.POINT.GEN.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects all customers with current birthday ids
*  This routine is the SELECT routine of the batch REDO.B.LY.POINT.GEN which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243      Initial Creation
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Service

    $INSERT I_REDO.B.LY.POINT.GEN.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    SEL.LIST = ''
    IF PRG.RECSEL EQ 'Y' THEN
        SEL.ACC.CMD = 'SELECT ':FN.ACCT.ENT.TODAY
        SEL.LIST = ''
        CALL EB.READLIST(SEL.ACC.CMD,SEL.LIST,'',ID.CNT,'')
    END
*CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 AUTO CONVERSION

RETURN

END
