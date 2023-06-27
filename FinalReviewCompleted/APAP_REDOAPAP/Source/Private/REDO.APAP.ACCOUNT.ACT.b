* @ValidationCode : Mjo2NTkwNDY4NDk6Q3AxMjUyOjE2ODQ4MzYwMzI0OTE6SVRTUzotMTotMTotMzE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -31
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.ACCOUNT.ACT
*-----------------------------------------------------------------------------
* Company   Name    : APAP Bank
* Developed By      : Temenos Application Management
* Program   Name    : REDO.APAP.ACCOUNT.ACT
*---------------------------------------------------------------------------------
* Description       : REDO.APAP.ACCOUNT.ACT is an L type template; this template
*                     is used to store the account numbers copied from the core table
*                    ACCOUNT.ACT and is updated by a local batch job
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20-Jun-2013      Arundev KR            PACS00293038            Initial creation
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------

    Table.name               = 'REDO.APAP.ACCOUNT.ACT'        ;* Full application name including product prefix
    Table.title              = 'REDO.APAP.ACCOUNT.ACT'        ;* Screen title
    Table.stereotype         = 'L'        ;* H, U, L, W or T
    Table.product            = 'AC'       ;* Must be on EB.PRODUCT
    Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
    Table.Classicication     = 'FIN'      ;* As per FILE.CONTROL
    Table.relatedFiles       =  ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
    Table.equatePrefix       = 'REDO.ACC.ACT'       ;* Use to create I_F.EB.LOG.PARAMETER

*-----------------------------------------------------------------------------

    Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functio
    Table.trigger            = ''         ;* Trigger field used for OPERATION style

*-----------------------------------------------------------------------------

RETURN

*---------------------------------------------------------------------------------
END
