*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.REQ.STATUS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACI POPULAR DE AHORROS Y PRTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.CARD.REQ.STATUS
*By                : Kavitha
*Initial Creation  : 3-Mar-2011
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-----------------------------------------------------------------------------
  Table.name = 'REDO.CARD.REQ.STATUS'
  Table.title = 'Card Request Status'
  Table.stereotype = 'H'
  Table.product = 'EB'
  Table.subProduct = ''
  Table.classification = 'INT'
  Table.systemClearFile = 'Y'
  Table.relatedFiles = ''
  Table.isPostClosingFile = ''
  Table.equatePrefix = 'XX.YY'
*-----------------------------------------------------------------------------
  Table.idPrefix = ''
  Table.blockedFunctions = ''
  Table.trigger = ''
*-----------------------------------------------------------------------------

  RETURN

END
