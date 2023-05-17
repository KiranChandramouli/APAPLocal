SUBROUTINE REDO.CHQ.PRNT.VERSIONS
*-----------------------------------------------------------------------------
* @H-Type Application
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE           WHO           REFERENCE         DESCRIPTION

* 08.03.2011    SHANKAR RAJU  ODR-2010-03-0447    INITIAL CREATION
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------
    Table.name = 'REDO.CHQ.PRNT.VERSIONS' ;* Full application name including product prefix
    Table.title = 'VERSIONS FOR CHEQUES PRINTING'   ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'PRINT.CHQ.LIST' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
