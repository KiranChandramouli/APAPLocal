*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VIRTUAL.BRANCH

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :
*DESCRIPTION    :TEMPLATE USED TO POPULATE THE LOCAL FIELD L.CU.EDU.LEVEL
*LINKED WITH    :LOCAL FIELD L.CU.EDU.LEVEL
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL

*MODIFICATION DETAILS:
*        03NOV09 ODR-2009-10-0526


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-------------------------------------------------------------------------
  Table.name = 'REDO.VIRTUAL.BRANCH'    ;* Full application name incl
  Table.title = 'VIRTUAL BRANCH TABLE'  ;* Screen title
  Table.stereotype = 'U'      ;* H, U, L, W or T
  Table.product = 'ST'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'CST'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'CUS'  ;* Use to create I_F.EB.LOG.PARAMETE
*-------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked
  Table.trigger = ''

  RETURN
END
