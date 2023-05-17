*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.TXN.PARAM
*-----------------------------------------------------------------------------
*<doc>
* It's needed to have a concat file where, we can find all contract's those belong
* to any specific customer. REDO.CUS.TXN.CONCAT
*
* This application allows to set parameters associated with the "capture" processing
*
*
* It has only record, SYSTEM
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
  Table.name = 'REDO.CUS.TXN.PARAM'     ;* Full application name including product prefix
  Table.title = 'Customer Transactions - Parameters'        ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.CUS.TP'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = 'V'          ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
