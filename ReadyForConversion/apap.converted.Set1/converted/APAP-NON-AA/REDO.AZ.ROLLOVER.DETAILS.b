SUBROUTINE REDO.AZ.ROLLOVER.DETAILS
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO         REFERENCE           DESCRIPTION
* 23-Jun-2011   H GANESH       PACS00033292 - N.16  INITIAL CREATION
*
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.AZ.ROLLOVER.DETAILS'         ;* Full application name including product prefix
    Table.title = 'ROLLOVER DEPOSIT DETAILS'        ;* Screen title
    Table.stereotype = 'U'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.AZ.ROLL'   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
