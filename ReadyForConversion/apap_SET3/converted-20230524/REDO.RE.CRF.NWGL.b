* Modification History :
*-----------------------
* 07/12/22 - JAYASURYA
*            New Template changes
* ----------------------------------------------------------------------------
SUBROUTINE REDO.RE.CRF.NWGL
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

    Table.name = 'REDO.RE.CRF.NWGL'          ;* Full application name including product prefix
    Table.title = 'REDO RE CRF'         ;* Screen title
    Table.stereotype = 'T'    ;* H, U, L, W or T
    Table.product = 'RE'      ;* Must be on EB.PRODUCT
    Table.subProduct = ''     ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'FRP'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'CRF'          ;* Use to create I_F.EB.LOG.PARAMETER

RETURN
END
