SUBROUTINE REDO.PAYOFF.TERM.PARAM.FIELDS
*-----------------------------------------------------------------------------
*This routine is used to define id and fields for the table REDO.PAYOFF.TERM.PARAM
*-----------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 02-01-2012        S.MARIMUTHU     PACS00146863         Initial Creation
*-----------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '6'
    ID.F = '@ID'
    ID.T = ''
    ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
* CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName = 'XX<PRODUCT'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile('REDO.PRODUCT')

    fieldName = 'XX>TERM'
    fieldLength = '4'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
