*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FX.CCY.POSN
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Template Name : REDO.FX.CCY.POSN
*-----------------------------------------------------------------------------
* Description : This is the template definition routine to create the
* table REDO.CAMPAIGN.TYPES
* ----------------------------------------------------------------------------
* Input/Output:
*----------------
* IN : NA
* OUT : NA
*----------------
*
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------

*  DATE             WHO        REFERENCE             DESCRIPTION
* 6-8-2010      PREETHI MD     INITIAL CREATION

* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.FX.CCY.POSN'       ;* Full application name including product prefix
  Table.title = 'REDO.FX.CCY.POSN'      ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'FX'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.FX'        ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
