SUBROUTINE REDO.FI.LB.BPROC
*-----------------------------------------------------------------------------
*<doc>
* This table is used to store a log for flat intefaces
* @author avelasco@temenos.com
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 10/11/10 - C18 New template creation ODR-2010-03-0025
*
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.FI.LB.BPROC'       ;* Full application name including product prefix
    Table.title = 'PROCESO PLANILLAS BATCH'         ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.FI.LB.BPROC'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
