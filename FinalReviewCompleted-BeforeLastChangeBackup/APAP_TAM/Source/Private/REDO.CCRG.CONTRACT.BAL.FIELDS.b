* @ValidationCode : MjotNjg3NTc4NjI1OkNwMTI1MjoxNjgwNjcxNzU1ODUyOklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.CONTRACT.BAL.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.CONTRACT.BAL
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/04/2011 - APAP : B5
*              First Version
*
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
    $INSERT I_F.EB.PRODUCT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY

*** </region>
*-----------------------------------------------------------------------------

    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
    args = ''
    CALL Table.addOptionsField("SYSTEM.ID","AA_FX_MM_SC_LI",args,"")
    CHECKFILE(Table.currentFieldPosition) = "EB.PRODUCT" : @FM : EB.PRD.DESCRIPTION : @FM :"L.A"

    args = ''
    CALL Table.addFieldDefinition("PRIMARY.OWNER", 10, "CUS", args )
    CHECKFILE(Table.currentFieldPosition) = "CUSTOMER" : @FM : EB.CUS.SHORT.NAME : @FM :"L.A"

    args = ''
    CALL Table.addFieldDefinition("XX<OTHER.PARTY", 10, "CUS", args)
    CHECKFILE(Table.currentFieldPosition) = "CUSTOMER" : @FM : EB.CUS.SHORT.NAME : @FM :"L.A"

    args = ''
    CALL Table.addVirtualTableField("XX>ROLE", 'AA.PARTY.ROLE',args , '')

    args = ''
    CALL Table.addFieldDefinition("CATEGORY", 10, T24_String, args )
    CHECKFILE(Table.currentFieldPosition) = "CATEGORY" : @FM : EB.CAT.DESCRIPTION : @FM :"L.A"

    CALL Table.addVirtualTableField("XX<BALANCE.TYPE", 'REDO.CCRG.BAL.TYPE',args , '')

    CALL Table.addAmountField("XX-DIR.BALANCE", "", Field_Mandatory, '')

    CALL Table.addAmountField("XX-INT.RECEIVABLE", "", Field_Mandatory, '')

    CALL Table.addAmountField("XX>CON.BALANCE", "", Field_Mandatory, '')

    CALL Table.addReservedField("RESERVED.1")

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
