*-----------------------------------------------------------------------------
* <Rating>-19</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.H.PRODUCT.DEFINE
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.H.PRODUCT.DEFINE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.H.PRODUCT.DEFINE is an H type template; this template is used to record
*                    the allowed CATEGORIES for all MM contracts for which the accrual is to done
*                    using Effective rate method
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
  Table.name               = 'REDO.APAP.H.PRODUCT.DEFINE'   ;* Full application name including product prefix
  Table.title              = 'Product Definition' ;* Screen title
  Table.stereotype         = 'H'        ;* H, U, L, W or T
  Table.product            = 'EB'       ;* Must be on EB.PRODUCT
  Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
  Table.Classicication     = 'INT'      ;* As per FILE.CONTROL
  Table.relatedFiles       =  ''        ;* As per FILE.CONTROL
  Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
  Table.equatePrefix       = 'PRD.DEF'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functions
  Table.trigger            = ''         ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
  RETURN
END
