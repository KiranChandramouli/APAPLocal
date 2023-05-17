*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.NAB.HISTORY
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Puneet Kammar (puneetkammar@contractor.temenos.com)
* Program Name  : REDO.AA.NAB.HISTORY
*-----------------------------------------------------------------------------
* Description : This application is NAB Status Change
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-09-0029      21-Nov-2011          Initial draft
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.AA.NAB.HISTORY'    ;* Full application name including product prefix
  Table.title = 'NAB Status Change'     ;* Screen title
  Table.stereotype = 'U'      ;* H, U, L, W or T
  Table.product = 'AA'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'FIN'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.NAB.HIST'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
