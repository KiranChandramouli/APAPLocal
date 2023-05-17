SUBROUTINE REDO.RTE.CATEG.POSITION.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the REDO.RTE.CATEG.POSITION
* It contains the table definitions
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                  Reference            Description
* 16-NOV-2011    Pradeep S             PACS00142988         Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


    ID.F = '@ID' ; ID.N = '12'
    ID.T = ""    ; ID.T<2>  = 'SYSTEM'

    neighbour = ''
    fieldName = 'XX<DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-RTE.POSITION'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-XX<CATEG.INIT'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')

    neighbour = ''
    fieldName = 'XX>XX>CATEG.END'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')


    fieldName='RESERVED.6'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.5'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.4'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
