*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.TEMP.TYPE.PAY.FIELDS
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = 30
    ID.T = 'A'
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
*CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName = 'XX<TYPE.PAYMENT'
    fieldLength = '10'
    fieldType<1> = ''
    fieldType<2> = 'EFFECTIVO_CHEQUE'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX>TXN.REFERENCE'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
