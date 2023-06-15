* @ValidationCode : MjoxMTEyMDEwNjI4OkNwMTI1MjoxNjgwNjcxNzU1OTkzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:55
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
SUBROUTINE REDO.CCRG.RL.EFFECTIVE
*-----------------------------------------------------------------------------
*<doc>
* Allows to keep the information related with the customer that has been queried by user
*
* @author hpasquel@temenos.com
* @stereotype Application
* @package redo.ccrf
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 24/03/2011 - APAP : B5
*              First Version
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.CCRG.RL.EFFECTIVE' ;* Full application name including product prefix
    Table.title = 'Cus. Control Risk Group - Effective Ino'   ;* Screen title
    Table.stereotype = 'L'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'CUS'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.CCRG.RLE'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
