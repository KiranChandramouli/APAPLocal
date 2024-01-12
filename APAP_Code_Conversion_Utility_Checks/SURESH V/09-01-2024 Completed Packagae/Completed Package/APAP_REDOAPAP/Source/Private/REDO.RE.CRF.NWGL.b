* @ValidationCode : MjoxNzUyNTM3NTE1OkNwMTI1MjoxNjk3Njk4ODcyOTE3OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Oct 2023 12:31:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 07/12/22 - JAYASURYA
*            New Template changes
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*06/10/2023      Conversion tool            R22 Auto Conversion             Nochange
*06/10/2023      Suresh                     R22 Manual Conversion           Nochange
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
