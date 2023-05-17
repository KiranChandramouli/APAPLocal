SUBROUTINE REDO.APAP.L.CONTRACT.BALANCES
*-----------------------------------------------------------------------------
*<doc>
**********************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.L.CONTRACT.BALANCES
*---------------------------------------------------------------------------------
*Description       : REDO.APAP.L.CONTRACT.BALANCES is an L type template; this template
*                     is used to record the details on authorisation of MM.MONEY.MARKET
*                     with accrual as effective rate method
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 28 Sep 2010     Mudassir V         2000 ODR-2010-07-0077    Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name               = 'REDO.APAP.L.CONTRACT.BALANCES'          ;* Full application name including product prefix
    Table.title              = 'Contract Balances'  ;* Screen title
    Table.stereotype         = 'L'        ;* H, U, L, W or T
    Table.product            = 'EB'       ;* Must be on EB.PRODUCT
    Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
    Table.Classicication     = 'INT'      ;* As per FILE.CONTROL
    Table.relatedFiles       =  ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
    Table.equatePrefix       = 'CRT.BAL'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functio
    Table.trigger            = ''         ;* Trigger field used for OPERATION style
*-----------------------------------------------------------------------------
RETURN
END
