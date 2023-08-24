* @ValidationCode : MjotMTA1MTgxODkyNjpDcDEyNTI6MTY4MTIzOTA5MDk3NTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.L.SC.TRNYIELD.CHANGE
*-----------------------------------------------------------------------------
* DESCRIPTION:
*  This is a template definition for REDO.L.SC.TRNYIELD.CHANGE
*
* Input/Output:
*---------------
* IN  : -NA-
* OUT : -NA-
*
*-----------------------------------------------------------------------------------
* Revision History:
*------------------
*   Date               who                        Reference            Description
* 15-NOV-2010      Riyas Ahamad Basha J       ODR-2009-07-0083       Initial Creation
* 12.04.2023       Conversion Tool                R22                Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M                R22                Manual Conversion   - No changes
*
* -------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-----------------------------------------------------------------------------
    Table.name = 'REDO.L.SC.TRNYIELD.CHANGE'
    Table.title = 'REDO.L.SC.TRNYIELD.CHANGE'
    Table.stereotype = 'L'
    Table.product = 'SC'
    Table.subProduct = ''
    Table.classification = 'INT'
    Table.systemClearFile = 'Y'
    Table.relatedFiles = ''
    Table.isPostClosingFile = ''
    Table.equatePrefix = 'SC.YLD'
*-----------------------------------------------------------------------------
    Table.idPrefix = ''
    Table.blockedFunctions = ''
    Table.trigger = ''
*-----------------------------------------------------------------------------
RETURN
END
