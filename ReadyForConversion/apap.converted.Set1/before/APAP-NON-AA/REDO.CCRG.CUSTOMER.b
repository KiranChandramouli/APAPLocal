*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.CUSTOMER
*-----------------------------------------------------------------------------
*<doc>
* Allows to input the customer to consult
* "version to input customer to consult"
*
* @author anoriegal@temenos.com
* @stereotype Application
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 04/04/2011 - APAP : B5
*              First Version
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name              = 'REDO.CCRG.CUSTOMER'  ;* Full application name including product prefix
  Table.title             = 'Cus. Control Risk Group - Customer to Consult'     ;* Screen title
  Table.stereotype        = 'U'         ;* H, U, L, W or T
  Table.product           = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
  Table.classification    = 'CUS'       ;* As per FILE.CONTROL
  Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
  Table.relatedFiles      = ''          ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix      = 'REDO.CCRG.CUS'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix          = ''          ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions  = ''          ;* Space delimeted list of blocked functions
  Table.trigger           = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
