SUBROUTINE REDO.INTERFACE.MON.TYPE.FIELDS
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
    ID.F = '@ID'
    ID.N = '2'
    ID.T = '':@FM:'01_02_03_04_05_06_07_08_09'
*-----------------------------------------------------------------------------

    fieldName="MNEMONIC"
    fieldLength="10"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="DESCRIPTION"
    fieldLength="100"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="NOTIFY.ENABLE"
    fieldLength="2"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
