* @ValidationCode : MjotMjEwNTk4Mjg0MzpDcDEyNTI6MTcwMzA3MzU3MDcwNTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Dec 2023 17:29:30
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
SUBROUTINE REDO.B.APPLY.CHG.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.APPLY.CHG.SELECT
*---------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select the LATAM.CARD.ORDER ids
*---------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.APPLY.CHG
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*05-AUG-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* Date                  who                   Reference
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh             R22 Manual Conversion              CALL routine modified

*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.APPLY.CHG.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.ACCOUNT
    
    $USING EB.Service



    SEL.CMD.LCO = "SELECT ":FN.LATAM.CARD.CHARGE
    CALL EB.READLIST(SEL.CMD.LCO,SEL.LIST.LCO,'',NO.REC,PGM.ERR)
*   CALL BATCH.BUILD.LIST('',SEL.LIST.LCO)
    EB.Service.BatchBuildList('',SEL.LIST.LCO) ;*R22 Manual Conversion

RETURN

END
