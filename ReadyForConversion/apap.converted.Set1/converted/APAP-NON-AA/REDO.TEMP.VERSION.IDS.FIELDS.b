SUBROUTINE REDO.TEMP.VERSION.IDS.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.TEMP.VERSION.IDS.FIELDS
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is template .fields routine, for the template REDO.TEMP.VERSION.IDS
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 19-01-2011      MARIMUTHU S        HD1052244       Initial Creation
*-------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*-----------------------------------------------------------------------------
    fieldName = 'XX<TXN.ID'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'XX>PRV.TXN.ID'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*

    fieldName = 'XX<AUT.TXN.ID'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>PROCESS.DATE'
    fieldLength = '12'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<REV.TXN.ID'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>REV.TXN.DATE'
    fieldLength = '12'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.FT.TYPE'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
