*
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.RIEN4.AC.REP.OUT1
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.RIEN4.AC.REP.OUT1
*-----------------------------------------------------------------------------
*Description       :Table will hold the file details
*Linked With       :TEMPLATE Rtn
*In  Parameter     : N/A
*Out Parameter     : N/A
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'DR.REG.RIEN4.AC.REP.OUT1'       ;* Full application name including product prefix
    Table.title = 'Report RIEN4 AC Out Details'   ;* Screen title
    Table.stereotype = 'L'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = 'EB'   ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'FIN'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'DR.RIEN4.AC1.OUT'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

