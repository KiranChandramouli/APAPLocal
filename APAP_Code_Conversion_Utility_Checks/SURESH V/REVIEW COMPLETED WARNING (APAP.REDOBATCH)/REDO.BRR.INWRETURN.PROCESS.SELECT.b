* @ValidationCode : MjoxNTU4MDU5MTI3OkNwMTI1MjoxNzA0Nzg2MzE1MDYyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 13:15:15
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
SUBROUTINE REDO.BRR.INWRETURN.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns..
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP.
* DEVELOPED BY : NATCHIMUTHU
* PROGRAM NAME : REDO.B.INWRETURN.PROCESS.SELECT
* ODR          : ODR-2010-09-0148
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE          DESCRIPTION
* 30.09.2010     NATCHIMUTHU     ODR-2010-09-0148   INITIAL CREATION
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_F.REDO.CLEARING.PROCESS
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_REDO.BRR.INWRETURN.PROCESS.COMMON
    $USING EB.Service

    GOSUB PROCESS
RETURN

*********
PROCESS:
*********

    SEL.CMD= "SELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH STATUS EQ REJECTED AND WITH TRANS.DATE EQ ": TODAY
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
*    CALL BATCH.BUILD.LIST('',BUILD.LIST)
    EB.Service.BatchBuildList('',BUILD.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
*-----------------------------------------------------------------------------------------------------------------------------------
 