*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUSTOMER.ARRANGEMENT
*-----------------------------------------------------------------------------
*-----------------------
* Modification History :
*-----------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* ----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table

*-----------------------------------------------------------------------------
  Table.name = 'REDO.CUSTOMER.ARRANGEMENT'        ;* Full application name including product prefix
  Table.title = 'REDO.CUSTOMER.ARRANGEMENT'       ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'CUS.ARR'        ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
