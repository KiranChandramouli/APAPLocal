*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TEL.TYPE
*-----------------------------------------------------------------------------
*<doc>
* drop down list for L.CU.TEL.TYPE
* @author jananiks@temenos.com
* @stereotype Application
*
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*1 DEC 2009
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.TEL.TYPE'          ;* Full application name including product prefix
  Table.title = 'REDO.TEL.TYPE'         ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
