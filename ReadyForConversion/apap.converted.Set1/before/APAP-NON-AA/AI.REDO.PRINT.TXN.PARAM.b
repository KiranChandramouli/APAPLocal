*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AI.REDO.PRINT.TXN.PARAM
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here
* @author riyasbasha@temenos.com
* @stereotype Application
* Reference:ODR-2010-08-0031

* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 06/06/2012 -
*            New Template changes
* ---------------------------------------------------------------------------
*    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name       = 'AI.REDO.PRINT.TXN.PARAM'    ;* Full application name including product prefix
  Table.title      = 'Print Transaction Param'    ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product    = 'AI'     ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification    = 'FIN'       ;* As per FILE.CONTROL
  Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
  Table.relatedFiles      = ''          ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix      = 'AI.PRI'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix         = '' ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger          = '' ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
