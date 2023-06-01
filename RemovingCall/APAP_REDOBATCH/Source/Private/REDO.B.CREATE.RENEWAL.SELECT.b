* @ValidationCode : MjotMTQ1ODM5MzkxMzpDcDEyNTI6MTY4NDg1NDM4MzU5OTpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CREATE.RENEWAL.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.CREATE.RENEWAL.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the expiry date equal to last working day
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.CREATE.RENEWAL
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*12-08-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*27 MAY 2011   KAVITHA                PACS00063156          PACS00063156 FIX
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CREATE.RENEWAL.COMMON
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON

*PACS00063156-S
    SEL.CMD.CR = "SELECT ":FN.REDO.CARD.RENEWAL
    CALL EB.READLIST(SEL.CMD.CR,SEL.LIST.CR,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST.CR)
RETURN
*PACS00063156-E

END
