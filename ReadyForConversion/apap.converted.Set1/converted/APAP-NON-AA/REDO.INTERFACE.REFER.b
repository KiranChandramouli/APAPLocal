SUBROUTINE REDO.INTERFACE.REFER
*-----------------------------------------------------------------------------
*<doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 13/10/2010 - C.22 New Template creation
*
* ----------------------------------------------------------------------------
* <region name= Inserts>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.INTERFACE.REFER'   ;* Full application name including product prefix
    Table.title = 'Actividad Interfaces de referencia '       ;* Screen title
    Table.stereotype = 'L'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = 'CUSTOMER'         ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'N' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.INT.REF'   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
