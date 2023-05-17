*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ADD.THIRDPARTY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="8"
  ID.T="A"
*-----------------------------------------------------------------------------
  fieldName   ="CUSTOMER.NAME"
  fieldLength ="35.1"
  fieldType   ="A"
  neighbour   =""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)


  fieldName  ="CUSTOMER.ID"
  fieldLength="35"
  fieldType  ="A"
  neighbour  =""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName  ="ALIAS"
  fieldLength="35"
  fieldType  ="A"
  neighbour  =""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName  ="EMAIL"
  fieldLength="35"
  fieldType   ="A"
  neighbour   =""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName  ="TYPE.OF.SERVICE"
  fieldLength='35'
  fieldType  ="A"
  neighbour  =""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.THIRDPRTY.PARAMETER")

  fieldName  ="CONTRACT.NO"
  fieldLength='35.1'
  fieldType  ="A"
  neighbour  =""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName  ="OWN.CUSTOMER"
  fieldLength='35.1'
  fieldType  ="A"
  neighbour  =""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="COMP.SERV.NAME"
  fieldLength="35"
  fieldType  = "A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.9"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.8"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.7"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.6"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fieldName="RESERVED.5"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.4"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.3"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.2"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.1"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  neighbour    = ''
  fieldName    = 'XX.LOCAL.REF'
  fieldLength  = '35'
  fieldType<3> = 'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour    = ''
  fieldName    = 'XX.OVERRIDE'
  fieldLength  = '35'
  fieldType<3> = 'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------

  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN

*-----------------------------------------------------------------------------
END
