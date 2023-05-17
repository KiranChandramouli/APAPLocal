SUBROUTINE REDO.CCRG.PARAMETERS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.PARAMETERS
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
    $INSERT I_F.EB.API
    $INSERT I_F.EB.PRODUCT


*** </region>
*-----------------------------------------------------------------------------
    dataType      = ''
    dataType<2>   = 16.1
    dataType<3>   = ''
    dataType<3,2> = 'SYSTEM'
    CALL Table.defineId("@ID", dataType)  ;* Define Table id
*-----------------------------------------------------------------------------
    fieldLength = "05.1.C"
    fieldType<4> = "R##:##"
    fieldType<5> = "C"
    CALL Table.addFieldDefinition("EFFECTIVE.TIME", fieldLength, fieldType, '')

    args = ''
    args = Field_Mandatory
    CALL Table.addOptionsField("XX<PRODUCT","AA_FX_MM_SC_LI",args,"")
    CHECKFILE(Table.currentFieldPosition) = "EB.PRODUCT" : @FM : EB.PRD.DESCRIPTION : @FM :"L.A"

    args = ''
    args = 'HOOK': @FM :Field_Mandatory
    CALL Table.addFieldDefinition("XX-EVALUATOR.RTN", '40',args , '')
    CHECKFILE(Table.currentFieldPosition) = "EB.API" : @FM : EB.API.DESCRIPTION : @FM :"L.A"

    args = ''
    args = 'HOOK': @FM :Field_Mandatory
    CALL Table.addFieldDefinition("XX-GET.BAL.RTN", '40', args, '')
    CHECKFILE(Table.currentFieldPosition) = "EB.API" : @FM : EB.API.DESCRIPTION : @FM :"L.A"

    CALL Table.addReservedField("XX>RESERVED.1")    ;* Add a new Reserved fields
    CALL Table.addReservedField("RESERVED.2")       ;* Add a new Reserved fields
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
