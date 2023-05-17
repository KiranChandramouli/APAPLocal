SUBROUTINE REDO.INTERFACE.SMAIL.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 26/07/2010 - C.22 New Template Creation
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

    ID.F = '@ID'
    ID.N = '6'
    ID.T = '':@FM:"SYSTEM"
*-----------------------------------------------------------------------------

    fieldName="USERNAME"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PASSWORD"
    fieldLength="35"
    fieldType="PASSWD"          ;* C.21
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="IP.ADDRESS"
    fieldLength="45.3"          ;* C.21
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PORT"
    fieldLength="5.1" ;* C.21
    fieldType="" : @FM : "0...99999"       ;* C.21
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="SSL.ENABLE"
    fieldLength="2.2" ;* C.21
    fieldType="":@FM:"SI_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* C.21 <<
    fieldName="AUTH.REQUIRED"
    fieldLength="2.2"
    fieldType="":@FM:"SI_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PROP.FILE"
    fieldLength="35.1"
* NonInput because java library searchs this file
    fieldType="A":@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setDefault('t24tamemail.properties')

* This path must be add to CLASSPATH
    fieldName="PROP.FILE.PATH"
    fieldLength="100.1"
    fieldType="DIR"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setDefault('./jars/T24TAMEmail/config')
* >>

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
