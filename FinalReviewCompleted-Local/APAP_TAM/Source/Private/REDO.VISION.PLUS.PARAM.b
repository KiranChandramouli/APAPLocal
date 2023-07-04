* @ValidationCode : Mjo5NDM3Mjc2MjU6Q3AxMjUyOjE2ODExOTM5MzM5MDk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:53
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
SUBROUTINE REDO.VISION.PLUS.PARAM
*-----------------------------------------------------------------------------
* <doc>
* Template to store Vision Plus execution parameters
* ============================================================================
* @author:     Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype: Application
* @package:    ST
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 17/04/2013 - Initial Version
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------

* <region name= Inserts>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

* </region>

*-----------------------------------------------------------------------------
    Table.name  = 'REDO.VISION.PLUS.PARAM'          ;* Full application name including product prefix
    Table.title = 'Vision Plus Parameters'          ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product    = 'ST'     ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'       ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles      = ''          ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix      = 'VP.PARAM'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix         = '' ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger          = '' ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
