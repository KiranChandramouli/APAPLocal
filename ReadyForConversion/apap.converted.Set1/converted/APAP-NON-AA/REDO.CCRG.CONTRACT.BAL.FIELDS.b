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
