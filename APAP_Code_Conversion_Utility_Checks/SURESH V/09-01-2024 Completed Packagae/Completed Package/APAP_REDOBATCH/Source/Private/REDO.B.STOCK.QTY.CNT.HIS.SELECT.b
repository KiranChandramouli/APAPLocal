* @ValidationCode : MjoxMTYzODkwNTc5OkNwMTI1MjoxNzA0NDQxODg2MTMxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:34:46
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
SUBROUTINE REDO.B.STOCK.QTY.CNT.HIS.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.STOCK.QTY.COUNT.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock register table
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.STOCK.QTY.COUNT
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*8-MARCH-2011    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANCES
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STOCK.QTY.COUNT.COMMON
    $INSERT I_GTS.COMMON
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.DATES
    $INSERT I_F.STOCK.REGISTER
    $USING EB.Service

    SEL.CMD.SR = "SELECT ":FN.STOCK.REGISTER:" WITH @ID LIKE ...CARD.":ID.COMPANY:"..."
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
    EB.Service.BatchBuildList('',SEL.LIST.SR);* R22 UTILITY AUTO CONVERSION
RETURN

END
