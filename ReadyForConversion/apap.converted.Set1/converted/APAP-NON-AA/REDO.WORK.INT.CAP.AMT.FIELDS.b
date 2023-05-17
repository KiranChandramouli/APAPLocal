SUBROUTINE REDO.WORK.INT.CAP.AMT.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.WORK.INT.CAP.AMT.FIELDS
*-----------------------------------------------------------------
* Description : This routine tempalte is used to store the details aa contracts int and principal
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      21-Nov-2011          Initial draft
*-----------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.F = '@ID'
    ID.N = 35
    ID.T = 'A'
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
*CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName = 'XX.INTEREST.TEXT'
    fieldLength = '60'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'XX.CAPITAL.TEXT'
    fieldLength = '60'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ENTRY'
    fieldLength = '3'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
*CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
