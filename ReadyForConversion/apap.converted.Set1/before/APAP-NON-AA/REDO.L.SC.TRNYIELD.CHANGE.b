*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.SC.TRNYIELD.CHANGE
*-----------------------------------------------------------------------------
* DESCRIPTION:
*  This is a template definition for REDO.L.SC.TRNYIELD.CHANGE
*
* Input/Output:
*---------------
* IN  : -NA-
* OUT : -NA-
*
*-----------------------------------------------------------------------------------
* Revision History:
*------------------
*   Date               who                        Reference            Description
* 15-NOV-2010      Riyas Ahamad Basha J       ODR-2009-07-0083       Initial Creation
* -------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-----------------------------------------------------------------------------
  Table.name = 'REDO.L.SC.TRNYIELD.CHANGE'
  Table.title = 'REDO.L.SC.TRNYIELD.CHANGE'
  Table.stereotype = 'L'
  Table.product = 'SC'
  Table.subProduct = ''
  Table.classification = 'INT'
  Table.systemClearFile = 'Y'
  Table.relatedFiles = ''
  Table.isPostClosingFile = ''
  Table.equatePrefix = 'SC.YLD'
*-----------------------------------------------------------------------------
  Table.idPrefix = ''
  Table.blockedFunctions = ''
  Table.trigger = ''
*-----------------------------------------------------------------------------
  RETURN
END
