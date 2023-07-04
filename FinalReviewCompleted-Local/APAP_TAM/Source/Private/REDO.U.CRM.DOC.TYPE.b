* @ValidationCode : Mjo3OTE4NTA0OTA6Q3AxMjUyOjE2ODMwMDE1MzQyNTk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 09:55:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.U.CRM.DOC.TYPE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.U.CRM.DOC.TYPE
*-----------------------------------------------------------------------------
* Description : This is the template definition routine to create the
* table REDO.U.CRM.DOC.TYPE
*<doc>
* TODO add a description of the application here
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 19/10/07 - EN_10003543
*            New Template changes
* ----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name               = 'REDO.U.CRM.DOC.TYPE'          ;* Full application name including product prefix
    Table.title              = 'DOC.TYPE' ;* Screen title
    Table.stereotype         = 'U'        ;* H, U, L, W or T
    Table.product            = 'EB'       ;* Must be on EB.PRODUCT
    Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
    Table.classification     = 'INT'      ;* As per FILE.CONTROL
    Table.systemClearFile    = 'Y'        ;* As per FILE.CONTROL
    Table.relatedFiles       = ''         ;* As per FILE.CONTROL
    Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
    Table.equatePrefix       = 'DOC.TYPE' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functions
    Table.trigger            = ''         ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
