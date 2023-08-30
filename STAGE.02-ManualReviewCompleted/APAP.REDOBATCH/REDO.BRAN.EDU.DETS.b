* @ValidationCode : MjotOTk1MDIzNjk2OkNwMTI1MjoxNjgxNzEwNTg0NzExOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:19:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BRAN.EDU.DETS

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :
*DESCRIPTION    :TEMPLATE USED TO POPULATE THE LOCAL FIELD L.CU.EDU.LEVEL
*LINKED WITH    :LOCAL FIELD L.CU.EDU.LEVEL
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL

*MODIFICATION DETAILS:
*        03NOV09 ODR-2009-10-0526
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-------------------------------------------------------------------------
    Table.name = 'REDO.BRAN.EDU.DETS'     ;* Full application name incl
    Table.title = 'CUSTOMER EDUCATION DETAILS'      ;* Screen title
    Table.stereotype = 'U'      ;* H, U, L, W or T
    Table.product = 'ST'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'CST'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'CUS'  ;* Use to create I_F.EB.LOG.PARAMETE
*-------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked
    Table.trigger = ''

RETURN
END
