*
    *-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.RIEN3.CONCAT
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.RIEN3.CONCAT
*-----------------------------------------------------------------------------
*Description       :Table will hold the file details
*Linked With       :TEMPLATE Rtn
*In  Parameter     : N/A
*Out Parameter     : N/A
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
* 29-Jan-2014 - New - Gangadhar.S.V.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'DR.REG.RIEN3.CONCAT'  ;* Full application name including product prefix
    Table.title = 'Report RIEN3 Concat table'
    Table.stereotype = 'T'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = 'EB'   ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'RIEN3.CONCAT'        ;* Use to create I_F.DR.REG.RIEN3.CONCAT
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END
