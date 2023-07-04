* @ValidationCode : MjotOTAyMTk1MzI0OkNwMTI1MjoxNjgxMDU2NDg1OTAwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

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
