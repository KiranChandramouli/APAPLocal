$PACKAGE APAP.TAM
SUBROUTINE REDO.H.APAP.PARAMETER
*-----------------------------------------------------------------------------
*<doc>
* The template routine for REDO.H.APAP.PARAMETER
* @author rvignesh@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 16/05/13 - Vignesh Kumaar M R
*            New Template
** 11-04-2023 R22 Auto Conversion no changes
** 11-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.H.APAP.PARAMETER'  ;* Full application name including product prefix
    Table.title = 'APAP Parameter Table'  ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'APAP' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
