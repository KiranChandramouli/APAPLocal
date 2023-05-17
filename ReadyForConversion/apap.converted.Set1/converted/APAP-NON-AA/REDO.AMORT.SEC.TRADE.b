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
