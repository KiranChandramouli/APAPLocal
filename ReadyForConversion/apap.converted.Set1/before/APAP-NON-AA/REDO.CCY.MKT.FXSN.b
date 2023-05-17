*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCY.MKT.FXSN
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here
* @author tchandru@temenos.com
* @stereotype Application
* Reference:ODR-2010-01-0213
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 01/02/2010 -
*            New Template changes
*-----------------------------------------------------------------------------
* Date             Author             Reference         Description
* 16-Sep-2010      Chandra Prakash T  ODR-2010-09-0014  Change Request CR 023 - CURRENCY MARKET & Exchange Rates
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------
*    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.CCY.MKT.FXSN'      ;* Full application name including product prefix
  Table.title = 'CURRENCY.MARKET Definition for FXSN'       ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.CMKT'      ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
