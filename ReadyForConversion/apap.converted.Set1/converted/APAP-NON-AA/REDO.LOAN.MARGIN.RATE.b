SUBROUTINE REDO.LOAN.MARGIN.RATE
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE           DESCRIPTION
* 16-Mar-2011     H GANESH     PACS00055012 - B.16  INITIAL CREATION

* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.LOAN.MARGIN.RATE'  ;* Full application name including product prefix
    Table.title = 'Loan Margin Rate'      ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.LO.MAR'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
