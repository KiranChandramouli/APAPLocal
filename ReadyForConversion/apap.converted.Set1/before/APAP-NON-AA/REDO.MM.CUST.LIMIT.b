*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MM.CUST.LIMIT
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CLEAR.PARAM
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CLEAR.PARAM is an H type template
*</doc>
*-----------------------------------------------------------------------------
* <region name= Inserts>

$INSERT I_COMMON

$INSERT I_EQUATE

$INSERT I_Table

* </region>

*-----------------------------------------------------------------------------

  Table.name = 'REDO.MM.CUST.LIMIT'     ;* Full application name including product prefix

  Table.title = 'Counter Party Parameter'         ;* Screen title

  Table.stereotype = 'H'      ;* H, U, L, W or T

  Table.product = 'EB'        ;* Must be on EB.PRODUCT

  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT

  Table.classification = 'INT'          ;* As per FILE.CONTROL

  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL

  Table.relatedFiles = ''     ;* As per FILE.CONTROL

  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL

  Table.equatePrefix = 'CUST.LIM'       ;* Use to create I_F.EB.LOG.PARAMETER

*-----------------------------------------------------------------------------

  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set

  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions

  Table.trigger = ''          ;* Trigger field used for OPERATION style fields

*-----------------------------------------------------------------------------

  RETURN
END
