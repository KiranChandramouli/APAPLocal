* @ValidationCode : MjotMTM1MjM1ODk4MzpDcDEyNTI6MTY4Mzg5MjYzNTEyOTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.DEPOSIT.RECEIPTS
*-----------------------------------------------------------------------------
* Description:
* This is a template definition for REDO.H.DEPOSIT.RECEIPTS
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.H.DEPOSIT.RECEIPTS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.H.DEPOSIT.RECEIPTS'          ;* Full application name including product prefix
    Table.title = 'DEPOSIT RECEIPTS'      ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'CUS'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.DEP'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
