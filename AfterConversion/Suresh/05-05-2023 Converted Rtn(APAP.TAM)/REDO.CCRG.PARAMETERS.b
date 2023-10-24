* @ValidationCode : MjotMTg5ODU5NDIyNjpDcDEyNTI6MTY4MDY4MjIxOTA4MTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:40:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.PARAMETERS
*-----------------------------------------------------------------------------
*<doc>
* This APPLICATION allows you TO define parameters that determine the different behavior
* or values ​​required to meet the requested processing.
*
*-----------------------------------------------------------------------------
* @author anoriega@temenos.com
* @stereotype Application
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 04/04/2011 - APAP : B5
*              First Version
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name              = 'REDO.CCRG.PARAMETERS'          ;* Full application name including product prefix
    Table.title             = 'Cus. Control Risk Group - Parameters'    ;* Screen title
    Table.stereotype        = 'H'         ;* H, U, L, W or T
    Table.product           = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'REDO.CCRG.P'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix         = '' ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger          = '' ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
