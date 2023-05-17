*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.TXN.CONCAT
*-----------------------------------------------------------------------------
*<doc>
* It's needed to have a concat file where, we can find all contract's those belong
* to any specific customer. REDO.CUS.TXN.CONCAT
*
* This CONCAT file allows to keep the relation CUSTOMER>CONTRACT.
*
* The records on this file will be feed from a VERSION.CONTROL routine. The routine
* is called via "OFS message", this will check (againts REDO.CUS.TXN.PARAM) if the
* transaction has to be catched or not
*
*
* @author hpasquel@temenos.com
* @stereotype Application
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 22/03/2011 - APAP : B5  ODR-2011-03-0154
*              First Version
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.CUS.TXN.CONCAT'    ;* Full application name including product prefix
  Table.title = 'Customer Transactions - Concat File'       ;* Screen title
  Table.stereotype = 'T'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'CUS'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = ''     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
