* @ValidationCode : MjotMTM5MjkyOTA0NDpDcDEyNTI6MTY4NDg0MTg5NjIzOTpJVFNTOi0xOi0xOi0xNToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:16
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM
*-----------------------------------------------------------------------------
*<doc>
* To keep the rate and corresponding value (in terms of technical reserves) for each of the risk limits to create.
* @author anoriega@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 14/March/2011 - EN_10003543
*                 New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name              = 'REDO.CCRG.RISK.LIMIT.PARAM'    ;* Full application name including product prefix
    Table.title             = 'RISK LIMIT PARAMETER'          ;* Screen title
    Table.stereotype        = 'H'         ;* H, U, L, W or T
    Table.product           = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'REDO.CCRG.RLP'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''          ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''          ;* Space delimeted list of blocked functions
    Table.trigger           = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
