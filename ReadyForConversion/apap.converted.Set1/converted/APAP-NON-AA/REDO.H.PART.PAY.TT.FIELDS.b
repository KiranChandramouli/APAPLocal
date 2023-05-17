SUBROUTINE REDO.H.PART.PAY.TT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.H.PART.PAY.TT.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009110157
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '25'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'ARRANGEMENT.ID'
    fieldLength = '25'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'BILL.NUMBER'
    fieldLength = '25'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'PARTL.PYMT.PCNT'
    fieldLength = '10'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'NUMBER.OF.PYMTS'
    fieldLength = '10'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'AMOUNT'
    fieldLength = '25'
    fieldType = "AMT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'CURRENCY'
    fieldLength = '3'
    fieldType = ""
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('CURRENCY')

    fieldName = 'VALUE.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
