* @ValidationCode : MjotMTQ5NzU3NjY0NTpDcDEyNTI6MTY4MjMzMTU2NDc5NzpJVFNTOi0xOi0xOi0xNToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.INSTIT.FINANC.PARAM
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*  21.04.2023       Conversion Tool          R22                  Auto Conversion     - $INCLUDE T24.BP TO $INSERT
*  21.04.2023       Shanmugapriya M          R22                  Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON             ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE             ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_Table              ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.APAP.INSTIT.FINANC.PARAM' ;* Full application name including product prefix
    Table.title = 'Institute Financials'  ;* Screen title
    Table.stereotype = 'H'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = ''     ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'INST.FIN'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
