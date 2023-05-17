SUBROUTINE APAP.H.INSURANCE.EVENTFIELD
*-----------------------------------------------------------------------------
*<doc>
*
* @authors jvalarezoulloa@temenos.com, pgarzongavilanes@temenos.com,sjijon@temenos.com
* @stereotype template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - APAP.H.INSURANCE.EVENTFIELD.FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 16/06/11 - New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'APAP.H.INSURANCE.EVENTFIELD'      ;* Full application name including product prefix
    Table.title = 'INSURANCE.EVENTFIELD'  ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'INS.EVF'        ;* Use to create I_F.REDO.CLASS.TYPE
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
