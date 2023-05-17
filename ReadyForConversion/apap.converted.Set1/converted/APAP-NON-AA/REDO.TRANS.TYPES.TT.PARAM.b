SUBROUTINE REDO.TRANS.TYPES.TT.PARAM
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.TRANS.TYPES.FT.PARAM
* ODR NUMBER    : ODR-2010-03-0131
*----------------------------------------------------------------------------
* Description   : This is Template routine will define the template type
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-03-2011      MARIMUTHU s     ODR-2010-03-0131   Initial Creation
* ---------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.TRANS.TYPES.TT.PARAM'        ;* Full application name including product prefix
    Table.title = 'TXN TYPES PARAM TABLE - TT'      ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.TXN.TT'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
