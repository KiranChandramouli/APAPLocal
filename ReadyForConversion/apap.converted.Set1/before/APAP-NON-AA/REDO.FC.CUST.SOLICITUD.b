*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CUST.SOLICITUD
*-----------------------------------------------------------------------------
*<doc>
* PACS00051761
* APAP - Fabrica de Credito
* CONCAT FILE > Customer - Solicitud (App. Definition)
* @author lpazminodiaz@temenos.com
* @stereotype Concat File
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 05/05/11 - Initial Version
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.FC.CUST.SOLICITUD' ;* Full application name including product prefix
  Table.title = 'SOLICITIDES POR CLIENTE'         ;* Screen title
  Table.stereotype = 'T'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'FC.CUS.SOL'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
