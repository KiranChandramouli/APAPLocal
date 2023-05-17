*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUSTOMER.PARAM

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.CUSTOMER.PARAM
*DESCRIPTION    :This table contain the information of AC.ENTRY.PARAM for the customer
*
*LINKED WITH    :LOCAL FIELD RISK.GROUP IN CUSTOMER APPLICATION
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL

*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-------------------------------------------------------------------------
  Table.name = 'REDO.CUSTOMER.PARAM'    ;* Full application name incl
  Table.title = 'REDO.CUSTOMER.PARAM'   ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'FIN'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'ACP'  ;* Use to create I_F.EB.LOG.PARAMETE
*-------------------------------------------------------------------------
  Table.idPrefix = '0'        ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked
  Table.trigger = ''

  RETURN
END
