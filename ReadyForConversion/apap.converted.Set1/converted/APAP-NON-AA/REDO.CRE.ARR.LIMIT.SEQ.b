SUBROUTINE REDO.CRE.ARR.LIMIT.SEQ
*-----------------------------------------------------------------------------
*<doc>
* Related with REDO.CREATE.ARRANGEMENT application
* This live.file allows to keep the information about the last limit.ref.sequence used when}
* the limit was created for the corresponding customer
* @author hpasquel@temenos.com
* @stereotype Application
* @package redo.create.arrangement
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 07/01/11 - First Version
*            New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.CRE.ARR.LIMIT.SEQ' ;* Full application name including product prefix
    Table.title = 'Create Arr. Limit Seq' ;* Screen title
    Table.stereotype = 'L'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'CUS'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = ''     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
