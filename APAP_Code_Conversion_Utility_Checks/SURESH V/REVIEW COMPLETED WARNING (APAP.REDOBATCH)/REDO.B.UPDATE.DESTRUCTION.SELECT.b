* @ValidationCode : MjotMTkzMTc0OTEzMTpDcDEyNTI6MTcwNDcwNzUxNjUzOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jan 2024 15:21:56
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
SUBROUTINE REDO.B.UPDATE.DESTRUCTION.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.UPDATE.DESTRUCTION.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock entry table with INOUT.DATE equal to Last working date & TO.REGISTER equal to CARD.ID-COMPANY
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.UPDATE.DESTRUCTION
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.DESTRUCTION.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.DES.HIS
    $INSERT I_F.REDO.CARD.REORDER.DEST
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_GTS.COMMON
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.DATES
    $USING EB.Service



    SEL.CMD.SE = "SELECT ":FN.REDO.CARD.REQUEST:" WITH BR.RECEIVE.DATE EQ ":Y.LAST.WORKING.DATE:" AND WITH STATUS EQ 6 "
    CALL EB.READLIST(SEL.CMD.SE,SEL.LIST.SE,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST.SE)
    EB.Service.BatchBuildList('',SEL.LIST.SE);* R22 UTILITY AUTO CONVERSION
RETURN
 
END
