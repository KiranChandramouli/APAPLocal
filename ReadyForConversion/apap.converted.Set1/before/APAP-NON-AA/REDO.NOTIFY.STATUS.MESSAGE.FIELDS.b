*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOTIFY.STATUS.MESSAGE.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*  DATE             WHO         REFERENCE         DESCRIPTION
* 18-Apr-2011   H GANESH       PACS00033637    INITIAL CREATION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F='@ID'
  ID.N='65'
  ID.T='A'
  ID.CHECKFILE="STANDARD.SELECTION"

  fieldName='XX<NOTIFY.MSG'
  virtualTableName = 'L.AC.NOTIFY.1'
  neighbour=''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


  fieldName='XX-ACCT.FIELD.NAME'
  fieldLength='35.1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX-OVERRIDE.MSG'
  fieldLength='35.1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("OVERRIDE")

  fieldName='XX>ACCT.FIELD.POS'
  fieldLength='35'
  fieldType=''
  fieldType<3>='NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  CALL Table.addReservedField('RESERVED.10')
  CALL Table.addReservedField('RESERVED.9')
  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

  CALL Table.addOverrideField

  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-----------------------------------------------------------------------------
END
