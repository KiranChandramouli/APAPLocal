SUBROUTINE REDO.CAPTURE.CREDIT.VOUCHER
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPTURE.CREDIT.VOUCHER
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a template routine. This template is used for capturing the
*                    credit voucher details.
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11-Nov-2019      Vignesh Kumaar M R   CREDIT VOUCHER            INITIAL DRAFT
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.CAPTURE.CREDIT.VOUCHER'    ;* Full application name including product prefix
    Table.title = 'ATM Credit Voucher'  ;* Screen title
    Table.stereotype = 'H'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = ''     ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'ATM.CRED'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
