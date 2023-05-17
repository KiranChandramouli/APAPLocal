*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BUY.SELL.SOURCE
*-----------------------------------------------------------------------------
*<doc>
* @author spradeep@temenos.com
* @stereotype Application
* @package *
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 01/11/10 - First Version
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.BUY.SELL.SOURCE'   ;* Full application name including product prefix
  Table.title = 'Source Type' ;* Screen title
  Table.stereotype = 'U'      ;* H, U, L, W or T
  Table.product = 'FX'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = 'EB.EXTERNAL.USER'         ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'BS.SRC'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
