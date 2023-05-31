* @ValidationCode : MjoyNDkzMjg5MDk6Q3AxMjUyOjE2ODEyODM5MzY3ODE6SVRTUzotMTotMTotMjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AMORT.SEC.TRADE
*-----------------------------------------------------------------------------
*<doc>
* This is a local template to hold trade nominal values created for SC002
* @author rshankar@temenos.com
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 03/12/2010 - ODR-2010-07-0081
*            New Template creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------
    Table.name = 'REDO.AMORT.SEC.TRADE'
    Table.title = 'REDO.AMORT.SEC.TRADE'
    Table.stereotype = 'L'
    Table.product = 'EB'
    Table.subProduct = ''
    Table.classification = 'INT'
    Table.systemClearFile = 'Y'
    Table.relatedFiles = ''
    Table.isPostClosingFile = ''
    Table.equatePrefix = 'APAP.AMORT.ST'
*-----------------------------------------------------------------------------
    Table.idPrefix = ''
    Table.blockedFunctions = ''
    Table.trigger = ''
*-----------------------------------------------------------------------------

RETURN
END
