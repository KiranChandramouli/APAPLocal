* @ValidationCode : MjotOTMxMDYwMDQxOkNwMTI1MjoxNjgwNjE5NzU3NzU2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 20:19:17
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
SUBROUTINE REDO.CCRG.RL.LOG
*-----------------------------------------------------------------------------
*<doc>
* Log file that stores the client IN process
* @author:                 anoriega@temenos.com
* @stereotype Application:
* @package TODO define the product group and product, REDO.CCRG
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 01/April/2011 - EN_10003543
*                 New Template changes
*
* Date           Who                 Ref                  Modification
* 04.04.2023    Conversion Tool      R22                 Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22                 Manual Conversion   - No changes
*
*----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name              = 'REDO.CCRG.RL.LOG'    ;* Full application name including product prefix
    Table.title             = 'CCRG LOG PROCESS'    ;* Screen title
    Table.stereotype        = 'T'         ;* H, U, L, W or T
    Table.product           = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct        = ''          ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'CUS'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'REDO.CCRG.LOG'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''          ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''          ;* Space delimeted list of blocked functions
    Table.trigger           = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
