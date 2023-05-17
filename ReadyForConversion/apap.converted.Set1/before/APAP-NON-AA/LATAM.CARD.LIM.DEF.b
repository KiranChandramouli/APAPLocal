*-------------------------------------------------------------------------
* <Rating>-13</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.LIM.DEF
*-------------------------------------------------------------------------
!** Properties AND Methods FOR TEMPLATE
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*!
*------------------------------------------------------------------------
*Revision History:
*------------------
* Date               who           Reference            Description
* 05/09/08           ARUN.P                            Initial Version
* 22-SEP-2010     Swaminathan         ODR-2010-03-0400   CHANGED TO R9 STANDARDS
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'LATAM.CARD.LIM.DEF'     ;* Full application name including product prefix
  Table.title = 'Latam Card Lim Def'    ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = ''  ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'LATAM.CALI.DEF' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
  RETURN
END
