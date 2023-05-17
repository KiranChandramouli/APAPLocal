SUBROUTINE REDO.LY.AIR.FILEGEN
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO         REFERENCE         DESCRIPTION
* 15-10-2014     RMONDRAGON  ODR-2009-12-0276   INITIAL CREATION
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-------------------------------------------------------------------------------------------------------------------------
    Table.name = 'REDO.LY.AIR.FILEGEN'    ;* Full application name including product prefix
    Table.title = 'LEALTAD - PARAMETROS GENERACION ARCHIVO MILLAS'      ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = 'CUSTOMER'         ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'N' ;* As per FILE.CONTROL
    Table.relatedFiles = 'CUSTOMER'       ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.AIRPAR'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
