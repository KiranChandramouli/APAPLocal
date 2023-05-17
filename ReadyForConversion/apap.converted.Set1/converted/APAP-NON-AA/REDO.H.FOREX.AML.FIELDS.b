SUBROUTINE REDO.H.FOREX.AML.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.H.FOREX.AML
*
* @author tchandru@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
* Date             Author             Reference         Description
* 21-Jun-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
* CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '15' ; ID.T = '' ; ID.T<2> = 'SYSTEM'
* ---------------------------------------------------------------------------

    fieldName = 'AML.CCY'
    fieldLength = '3.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('CURRENCY')

    fieldName = 'AMT.LIMIT.FCY'
    fieldLength = '25.1'
    fieldType = "AMT"
    fieldType<2,2> = LCCY
    fieldType<9>='HOT.FIELD'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'AMT.LIMIT.LCY'
    fieldLength = '32'
    fieldType = "AMT"
    fieldType<2,2> = LCCY
    fieldType<3> = "NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
