* @ValidationCode : MjotMTEwMTM3NzEzNDpDcDEyNTI6MTY4MTE5MzkzNDEyMDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:54
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
SUBROUTINE REDO.VP.PUNISHED.UPLOAD

******************************************************************************
* Company Name    : T24
* Developed By    : Mauricio Sthandier - msthandier@temenos.com
*
* Subroutine Type : T
* Attached to     : N/A
* Attached as     : N/A
* Primary Purpose : Definicion de REDO.VP.PUNISHED.UPLOAD
* Date:           : Jan 2015
*
* Incoming:
* ---------
* N/A
*
* Outgoing:
* ---------
* N/A
*
* Error Variables:
* ----------------
* N/A
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* MSR201405
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

    Table.name = 'REDO.VP.PUNISHED.UPLOAD'
    Table.title = 'REDO.VP.PUNISHED.UPLOAD'
    Table.stereotype = 'L'      ;* H, U, L, W or T
    Table.product = 'AA'
    Table.subProduct = ''
    Table.classification = 'INT'
    Table.systemClearFile = 'Y'
    Table.relatedFiles = ''
    Table.isPostClosingFile = ''
    Table.equatePrefix = 'PUN.UPL'
    Table.idPrefix = ''
    Table.blockedFunctions = ''
    Table.trigger = ''

RETURN

END
