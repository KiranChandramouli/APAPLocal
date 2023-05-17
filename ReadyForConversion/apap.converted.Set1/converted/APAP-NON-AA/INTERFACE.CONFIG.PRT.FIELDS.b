SUBROUTINE INTERFACE.CONFIG.PRT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine INTRF.MESSAGE.FIELDS
*
* @author:
*stereotype fields template
* @uses Table
* @public Table Creation
* @package
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*            New Template changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("INTRF.MSG.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX<INT.FLD.NAME","200","ANY","")
    CALL Table.addFieldDefinition("XX-INT.FLD.VAL","200","ANY","")
    fieldtype = @FM:"Y_N"
    CALL Table.addFieldDefinition("XX>INT.ENCRY","10",fieldtype,"")
*    fieldtype = FM:"#"

    CALL Table.addFieldDefinition("INT.MAIN.ENC","10","A","")
*    CALL Field.setDefault("#")
* fieldtype = FM:"|"
    CALL Table.addFieldDefinition("INT.SUB.ENC","10","A","")
*   CALL Field.setDefault("|")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------

END
