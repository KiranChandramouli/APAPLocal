* @ValidationCode : Mjo4MTc0MDA3NjA6Q3AxMjUyOjE2ODQ4MzYwNDI3NzA6SVRTUzotMTotMTotMzQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -34
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.L.AMORT.BALANCES
*-----------------------------------------------------------------------------
*<doc>
**********************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.L.AMORT.BALANCES
*---------------------------------------------------------------------------------
*Description       : REDO.APAP.L.CONTRACT.BALANCES is an L type template; this template
*                     is used to record the details on authorisation of MM.MONEY.MARKET
*                     with accrual as effective rate method
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 28 Sep 2010     SHANKAR RAJU        ODR-2010-07-0081         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name               = 'REDO.APAP.L.AMORT.BALANCES'   ;* Full application name including product prefix
    Table.title              = 'Amortization Balances'        ;* Screen title
    Table.stereotype         = 'L'        ;* H, U, L, W or T
    Table.product            = 'EB'       ;* Must be on EB.PRODUCT
    Table.subProduct         = ''         ;* Must be on EB.SUB.PRODUCT
    Table.Classicication     = 'INT'      ;* As per FILE.CONTROL
    Table.relatedFiles       =  ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile  = ''         ;* As per FILE.CONTROL
    Table.equatePrefix       = 'AMRT.BAL' ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix           = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions   = ''         ;* Space delimeted list of blocked functio
    Table.trigger            = ''         ;* Trigger field used for OPERATION style
*-----------------------------------------------------------------------------
RETURN
END
