* @ValidationCode : MjoxMzUxMDQ4OTE1OkNwMTI1MjoxNjgyNDIxNzY3ODM4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:52:47
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.PDF.HEADER.PROCESS

*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.PDF.HEADER.PROCESS

*-----------------------------------------------------------------------------

*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*---------------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

*-----------------------------------------------------------------------------

    PDF.HEADER = O.DATA
    CALL System.setVariable("CURRENT.SCA.PDF.HEADER",PDF.HEADER)
RETURN
END
