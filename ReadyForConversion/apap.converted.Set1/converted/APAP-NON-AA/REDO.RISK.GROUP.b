SUBROUTINE REDO.RISK.GROUP

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.RISK.GROUP
*DESCRIPTION    :TEMPLATE USED TO POPULATE THE LOCAL FIELD RISK.GROUP
*                IN CUSTOMER APPLICATION
*LINKED WITH    :LOCAL FIELD RISK.GROUP IN CUSTOMER APPLICATION
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL

*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-------------------------------------------------------------------------
    Table.name = 'REDO.RISK.GROUP'        ;* Full application name incl
    Table.title = 'CUSTOMER RISK GROUP'   ;* Screen title
    Table.stereotype = 'U'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'CST'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'RG'   ;* Use to create I_F.EB.LOG.PARAMETE
*-------------------------------------------------------------------------
    Table.idPrefix = '0'        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked
    Table.trigger = ''

RETURN
END
