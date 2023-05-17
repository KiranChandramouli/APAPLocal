SUBROUTINE REDO.AZ.DISCOUNT.RATE
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a template routine. This is a parameter file to store the penalty rate
*                    for different date ranges
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 16/06/2010       Rekha  S         ODR-2009-10-0336 N.18        Initial Creation
* 06 MAY 2011     H GANESH          PACS00032973  - N.18         Changed the prefix
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.AZ.DISCOUNT.RATE'  ;* Full application name including product prefix
    Table.title = 'Penalty Rate'          ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'AZ'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.DIS.RATE'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
