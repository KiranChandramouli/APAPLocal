* @ValidationCode : MjoxNDIxOTcxNzE2OkNwMTI1MjoxNjgxMTkwMjA5NzkyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:46:49
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
SUBROUTINE REDO.B.DESTROY.CARDS.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.DESTROY.CARDS.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the REDO.CARD.DES.HIS id's with DEST.DATE equal to last working day + 1
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.DESTROY.CARDS
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*02-08-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.DESTROY.CARDS.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.DES.HIS
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CARD.NO.LOCK



    SEL.CMD.DH = "SELECT ":FN.REDO.CARD.DES.HIS:" WITH DEST.DATE LE ":Y.LAST.WORKING.DATE :" AND CARD.NUMBER EQ '' "
    CALL EB.READLIST(SEL.CMD.DH,SEL.LIST.DH,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST.DH)
RETURN

END
