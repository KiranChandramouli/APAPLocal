*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MVMT.COLLATERAL
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.MVMT.COLLATERAL
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.MVMT.COLLATERAL is an H type template
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 15 Feb 2012     Ganesh R          ODR-2010-03-0103          Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name              = 'REDO.MVMT.COLLATERAL'          ;* Full application name including product prefix
  Table.title             = 'REDO.MVMT.COLLATERAL'          ;* Screen title
  Table.stereotype        = 'L'         ;* H, U, L, W or T
  Table.product           = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
  Table.classification    = 'FIN'       ;* As per FILE.CONTROL
  Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
  Table.relatedFiles      = ''          ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix      = 'REDO.MVMT' ;* Use to create
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
  RETURN
END
