*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACCT.MRKWOF.PARAMETER
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.ACCT.MRKWOF.PARAMETER
*-----------------------------------------------------------------
* Description : This application is to parameterise the categor codes
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017    21-Nov-2011          Initial draft
* ----------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.ACCT.MRKWOF.PARAMETER'       ;* Full application name including product prefix
  Table.title = 'REDO.ACCT.MRKWOF.PARAMETER'      ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'RE.WOF.PAR'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
