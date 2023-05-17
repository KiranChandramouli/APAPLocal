*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.TC52.FILE
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
*Description:
*----------------
*This is the table to store the details of rejected transaction
*This holds copy of transaction original VISA settlement lines in REDO.VISA.SETTLEMENT.05TO37
*It will be used for enquiry purpose and record will be deleted once it is Approved or sent for Chargeback
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE                WHO           REFERENCE          DESCRIPTION
* 09-12-2010      Akthar Rasool S  ODR-2010-08-0469  INITIAL CREATION
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.VISA.TC52.FILE'    ;* Full application name including product prefix
  Table.title = 'REDO.VISA.TC52.FILE'   ;* Screen title
  Table.stereotype = 'U'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'VSA.TC52'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
