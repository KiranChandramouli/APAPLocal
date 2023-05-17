*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RATE.CHANGE.CRIT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : B Renugadevi
* PROGRAM NAME : REDO.RATE.CHANGE.CRIT
*-----------------------------------------------------------------------------
* Description : This is the template definition routine to create the
* table POOL.RATE
*<doc>
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who          Reference            Description
* 08-OCT-10    Kishore.SP   ODR-2009-10-0325      Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name               = 'REDO.RATE.CHANGE.CRIT'        ;* Full application name including product prefix
  Table.title              = 'RATE.CHANGE'        ;* Screen title
  Table.stereotype         = 'H'        ;* H, U, L, W or T
  Table.product            = 'AA'       ;* Must be on EB.PRODUCT
  Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
  Table.classification     = 'INT'      ;* As per FILE.CONTROL
  Table.systemClearFile    = 'Y'        ;* As per FILE.CONTROL
  Table.relatedFiles       = ''         ;* As per FILE.CONTROL
  Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
  Table.equatePrefix       = 'RATE.CHG' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functions
  Table.trigger            = ''         ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
