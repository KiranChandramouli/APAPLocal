SUBROUTINE REDO.VPLUS.MAPPING
*-----------------------------------------------------------------------------
* <doc>
* Template to store Vision Plus mapping values
* ============================================================================
* @author:     Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype: Application
* @package:    ST
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 17/04/2013 - Initial Version
* ----------------------------------------------------------------------------

* <region name= Inserts>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

* </region>

*-----------------------------------------------------------------------------
    Table.name  = 'REDO.VPLUS.MAPPING'    ;* Full application name including product prefix
    Table.title = 'Vision Plus Mapping'   ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product    = 'ST'     ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'VP.MAP'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix         = '' ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger          = '' ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
