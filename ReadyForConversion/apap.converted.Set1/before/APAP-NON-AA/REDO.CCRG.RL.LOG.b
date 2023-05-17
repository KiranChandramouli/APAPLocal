*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.RL.LOG
*-----------------------------------------------------------------------------
*<doc>
* Log file that stores the client IN process
* @author:                 anoriega@temenos.com
* @stereotype Application:
* @package TODO define the product group and product, REDO.CCRG
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 01/April/2011 - EN_10003543
*                 New Template changes
*----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name              = 'REDO.CCRG.RL.LOG'    ;* Full application name including product prefix
  Table.title             = 'CCRG LOG PROCESS'    ;* Screen title
  Table.stereotype        = 'T'         ;* H, U, L, W or T
  Table.product           = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
  Table.classification    = 'CUS'       ;* As per FILE.CONTROL
  Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
  Table.relatedFiles      = ''          ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix      = 'REDO.CCRG.LOG'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix          = ''          ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions  = ''          ;* Space delimeted list of blocked functions
  Table.trigger           = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
