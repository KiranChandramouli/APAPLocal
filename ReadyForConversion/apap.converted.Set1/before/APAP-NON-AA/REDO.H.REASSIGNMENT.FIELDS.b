*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.REASSIGNMENT.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.H.REASSIGNMENT
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.H.REASSIGNMENT.FIELDS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  GANESH R     ODR-2009-11-0200  INITIAL CREATION

*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("REDO.H.REASSIGNMENT", T24_String)    ;* Define Table id
  ID.F = '@ID'
  ID.N = '36'
  ID.T = 'A'

*-----------------------------------------------------------------------------
  fieldName = 'DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACCOUNT.NUMBER'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'ACCOUNT.NAME'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ITEM.CODE'
  fieldLength = '6'
  fieldType = 'A'
  neighbour =''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DESCRIPTION'
  fieldLength = '36'
  fieldType = 'A'
  neighbour =''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX.SERIES'
  fieldLength = '36'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REASON.FOR.ASSN'
  fieldLength = '36'
*    fieldType= '':FM:'Duplicate due to passbook loss_Duplicate due to passbook damage_Duplicate due to full passbook'
  fieldType = 'A'
  neighbour = ''
  virtualTableName = 'L.REASON.ASSING'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName = 'NEW.SERIES'
  fieldLength = '011'
  fieldType = ''
  fieldType<4> = 'R%11'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DEPT.DES'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DEPT'
  fieldLength = '20'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CODE'
  fieldLength = '20'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<1> = 'A'
  fieldType<3> = 'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
