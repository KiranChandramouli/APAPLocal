*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DISB.CHAIN
*----------------------------------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.DISB.CHAIN
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : Agosto 10 2011
*
*-----------------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
*************************************************************************

  Table.name = 'REDO.DISB.CHAIN'        ;* Full application name including product prefix
  Table.title = 'CADENA DESEMBOLSO'     ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = ''  ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'DS.CH'          ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields

  RETURN

END
