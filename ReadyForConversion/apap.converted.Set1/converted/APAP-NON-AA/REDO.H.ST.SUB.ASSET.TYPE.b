SUBROUTINE REDO.H.ST.SUB.ASSET.TYPE
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a REDO.H.ST.SUB.ASSET.TYPE.FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 14/10/2010 - Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name              = 'REDO.H.ST.SUB.ASSET.TYPE'      ;* Full application name including product prefix
    Table.title             = 'REDO.H.ST.SUB.ASSET.TYPE'      ;* Screen title
    Table.stereotype        = 'H'         ;* H, U, L, W or T
    Table.product           = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'FIN'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'REDO.SAT'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''          ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''          ;* Space delimeted list of blocked functions
    Table.trigger           = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
