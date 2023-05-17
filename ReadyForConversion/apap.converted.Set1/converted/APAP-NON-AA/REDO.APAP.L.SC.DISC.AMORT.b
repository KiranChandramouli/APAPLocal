SUBROUTINE REDO.APAP.L.SC.DISC.AMORT
*-----------------------------------------------------------------------------
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.L.CONTRACT.BALANCES
*---------------------------------------------------------------------------------
*Description       : REDO.APAP.L.SC.DISC.AMORT is an L type template; this template
*                     is used to store the effective discount rate and amount
*                    for the security trades
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 18-Feb-2013      Arundev KR             CR008 RTC-553577    Initial creation
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-----------------------------------------------------------------------------
    Table.name               = 'REDO.APAP.L.SC.DISC.AMORT'    ;* Full application name including product prefix
    Table.title              = 'Discount Amortisation'        ;* Screen title
    Table.stereotype         = 'L'        ;* H, U, L, W or T
    Table.product            = 'EB'       ;* Must be on EB.PRODUCT
    Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
    Table.Classicication     = 'INT'      ;* As per FILE.CONTROL
    Table.relatedFiles       =  ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
    Table.equatePrefix       = 'DISC.AMRT'          ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functio
    Table.trigger            = ''         ;* Trigger field used for OPERATION style
*-----------------------------------------------------------------------------

RETURN

END
