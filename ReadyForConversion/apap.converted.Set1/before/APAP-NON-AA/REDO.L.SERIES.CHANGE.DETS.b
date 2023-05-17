*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.SERIES.CHANGE.DETS
*-----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.L.SERIES.CHANGE.DETS'
  Table.title = 'REDO.L.SERIES.CHANGE.DETS'
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'AZ'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'FIN'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'AZ.CH.DETS'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
