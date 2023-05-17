SUBROUTINE REDO.ST.TXN.CODE.PARAM
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
    Table.name = 'REDO.ST.TXN.CODE.PARAM'
    Table.title = 'REDO.ST.TXN.CODE.PARAM'
    Table.stereotype = 'H'
    Table.product = 'EB'
    Table.subProduct = ''
    Table.classification = 'INT'
    Table.systemClearFile = 'Y'
    Table.relatedFiles = ''
    Table.isPostClosingFile = ''
    Table.equatePrefix = 'ST.TXN.CODE'
*-----------------------------------------------------------------------------
    Table.idPrefix = ''
    Table.blockedFunctions = ''
    Table.trigger = ''
*-----------------------------------------------------------------------------

RETURN
END
