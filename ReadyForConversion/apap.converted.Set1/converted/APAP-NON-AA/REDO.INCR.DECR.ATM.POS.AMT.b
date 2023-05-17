SUBROUTINE REDO.INCR.DECR.ATM.POS.AMT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Template Name : REDO.INCR.DECR.ATM.POS.AMT
*-----------------------------------------------------------------------------
* Description : REDO.INCR.DECR.ATM.POS.AMT is a L type template,
*               this template is used to record the maximum transaction limit amount for interfaces like ATM and POS
*               This template is updated on authorisation of the application LATAM.CARD.LIM.DEF,
*               the record ID will be today's date - Card type
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

*  DATE             WHO        REFERENCE                     DESCRIPTION
* 2-9-2010      PREETHI MD     ODR-2010-03-0106 131         INITIAL CREATION

* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.INCR.DECR.ATM.POS.AMT'       ;* Full application name including product prefix
    Table.title = 'Increase or Decrease ATM-POS Amount'       ;* Screen title
    Table.stereotype = 'L'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'ATM.POS'        ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
