* @ValidationCode : MjoxNjg3MzcwMDY2OkNwMTI1MjoxNzA0MzY0NjE0MTcyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:06:54
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
SUBROUTINE REDO.B.LY.GET.TXN.M.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the select routine of the batch job REDO.B.LY.GET.TXN.M which updates F.REDO.LY.TXN.BY.MOD file
* This routine selects the ACCT.ENT.TODAY file ids to be processed in the record routine of the batch job.
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA--
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
* Date                  who                   Reference
* 12-04-2023        CONVERSTION TOOL       R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Service

    $INSERT I_REDO.B.LY.GET.TXN.M.COMMON

    SEL.CMD = 'SELECT ':FN.ACCT.ENT.TODAY
    CALL EB.READLIST(SEL.CMD,ACCT.ENT.TODAY.LIST,'',NO.OF.REC,'')
*CALL BATCH.BUILD.LIST('',ACCT.ENT.TODAY.LIST)
    EB.Service.BatchBuildList('',ACCT.ENT.TODAY.LIST);* R22 AUTO CONVERSION

RETURN
END
