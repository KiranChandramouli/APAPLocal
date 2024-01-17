* @ValidationCode : Mjo1OTMyNzY4MTQ6Q3AxMjUyOjE3MDQ3MDg2NzE2NzQ6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 15:41:11
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
SUBROUTINE REDO.B.UPDATE.TRANSIT.BALANCE.SELECT
*--------------------------------------------------------------
*Description: This is the batch routine to update the transit balance
*             based on the release of ALE.
*Modification
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.TRANSIT.BALANCE.COMMON
    $USING EB.Service

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
* Main Process

    SEL.CMD = 'SELECT ':FN.REDO.TRANSIT.ALE:' WITH @ID LT ':TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
