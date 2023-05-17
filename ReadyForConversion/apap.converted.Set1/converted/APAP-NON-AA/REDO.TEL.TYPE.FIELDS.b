SUBROUTINE REDO.TEL.TYPE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author jananiks@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* 01 DEC 09
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.TEL.TYPE", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
*    CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields

*    CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName='XX.LL.DESCRIPTION'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESERVED.1'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESERVED.2'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESERVED.3'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    neighbour = ''


    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
