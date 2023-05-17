*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.BALANCE.TYPE.PARAM
*-----------------------------------------------------------------------------
*<doc>
* It's needed to associate a Balance Type with a contract. Being able to associate
* applications and their criteria (category, cus.relation.code), which allows   to
* relate a contract with one type of Balance
*
* For instance, we need to identify those contracts whose are considered as Secured
* operations
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
  Table.name = 'REDO.CCRG.BALANCE.TYPE.PARAM'     ;* Full application name including product prefix
  Table.title = 'Control Cus & Grp Risk - Bal Type Param'   ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.CCRG.BTP'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = 'V'          ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
