* @ValidationCode : MjotMzUxNTkzNTkxOkNwMTI1MjoxNzAzNjUzMjM2MjczOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 10:30:36
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
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CREATE.RENEWAL.COMMON
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.LATAM.CARD.ORDER
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    
    $USING EB.Service
 
*PACS00063156-S
    SEL.CMD.CR = "SELECT ":FN.REDO.CARD.RENEWAL
    CALL EB.READLIST(SEL.CMD.CR,SEL.LIST.CR,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST.CR)
    EB.Service.BatchBuildList('',SEL.LIST.CR) ;*R22 Manual Conversion
RETURN
*PACS00063156-E

END
