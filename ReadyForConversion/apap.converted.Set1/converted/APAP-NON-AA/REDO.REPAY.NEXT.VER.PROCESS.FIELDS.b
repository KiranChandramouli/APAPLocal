SUBROUTINE REDO.REPAY.NEXT.VER.PROCESS.FIELDS
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Marimuthu S
* Program Name : REDO.REPAY.NEXT.VER.PROCESS.FIELDS
*-----------------------------------------------------------------------------
* Description : This is .FIELDS routine for parameterisation of next version
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
*
*10/08/11       PACS00094144            Marimuthu S
*15/10/11       PACS00126000            Marimuthu S
*-----------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.F = '@ID'
    ID.N = '6'
    ID.T = ''
    ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
* CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1

* PACS00126000 -S
    virtualTableName = 'PAYMENT.METHOD'
    CALL EB.LOOKUP.LIST(virtualTableName)
    fieldName = 'XX<PAYMENT.METHOD'
    fieldLength = '35'
    fieldType = virtualTableName
* PACS00126000 -E
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'XX>PAYMENT.VERSION'
    fieldLength = '40'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*   CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*   CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
