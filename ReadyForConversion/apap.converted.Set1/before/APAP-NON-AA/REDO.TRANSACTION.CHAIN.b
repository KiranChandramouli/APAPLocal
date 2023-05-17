*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TRANSACTION.CHAIN
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here.
* @author jvalarezoulloa@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 29/03/2011 - Creation Date
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.TRANSACTION.CHAIN' ;* Full application name including product prefix
  Table.title = 'TRANSACTION CHAIN'     ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'RTC'  ;* Use to create I_F.EB.LOG.PARAMETER

  RETURN
END
