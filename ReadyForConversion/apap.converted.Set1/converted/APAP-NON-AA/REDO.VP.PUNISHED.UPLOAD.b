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
