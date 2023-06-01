* @ValidationCode : MjoxMTE1MzEwMTc2OkNwMTI1MjoxNjgxMjM5MDkwNjQzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:30
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
SUBROUTINE REDO.H.TELLER.TXN.CODES
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.TELLER.TXN.CODES
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a template routine. This template is used for defining the parameter
*                    details for SAP Interface
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
* 11 March 2011    Shiva Prasad Y      ODR-2010-03-0086 35         Initial Creation
* 12.04.2023       Conversion Tool       R22                       Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22                       Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.H.TELLER.TXN.CODES'          ;* Full application name including product prefix
    Table.title = 'Teller Txn Codes - Parameter'    ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'TT.TXN'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
