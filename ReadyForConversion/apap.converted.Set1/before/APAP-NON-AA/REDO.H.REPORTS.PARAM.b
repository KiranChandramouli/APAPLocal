*----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.REPORTS.PARAM
*-----------------------------------------------------------------------------
*<doc>
* Development Reference : DE04
* @author ->saranraj.subramani@capgemini.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 26-SEP-2013
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
*</region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.H.REPORTS.PARAM'   ;* Full application name including product prefix
  Table.title = 'REDO.H.REPORTS.PARAM'  ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.REP.PARAM'
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
