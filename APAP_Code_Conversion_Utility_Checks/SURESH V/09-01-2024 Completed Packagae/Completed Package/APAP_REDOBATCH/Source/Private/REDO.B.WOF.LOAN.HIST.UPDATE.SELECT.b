* @ValidationCode : MjoxNzE4OTQ4MDU6Q3AxMjUyOjE3MDQ3MTM5ODc4OTg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 17:09:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.WOF.LOAN.HIST.UPDATE.SELECT
*-----------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.WOF.LOAN.HIST.UPDATE
*-----------------------------------------------------------------
* Description : This routine is used to update the outstanding and paid interest and principal amt
*               in the local table REDO.ACCT.MRKWOF.HIST
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   21-Nov-2011          Initial draft
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.WOF.LOAN.HIST.UPDATE.COMMON
    $USING EB.Service
 

    SEL.CMD = 'SELECT ':FN.REDO.ACCT.MRKWOF.HIST:' WITH STATUS EQ INITIATED'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN

END
