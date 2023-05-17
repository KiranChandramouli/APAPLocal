*-----------------------------------------------------------------------------
* <Rating>-75</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PAY.TYPE.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the REDO.PAY.TYPE
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
*   Date            Who                    Reference             Description
*  21-SEP-2010  SWAMINATHAN.S.R          ODR-2009-12-0290      INITIAL VERSION
*  15-NOV-2011  Pradeep S                PACS00142988          New field added, RESERVED.6 = RTE.POSITION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes


*-----------------------------------------------------------------------------
*    CALL Table.defineId("REDO.CARD.REQUEST", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID' ; ID.N = '2'
  ID.T = ""   ;

  neighbour = ''
  fieldName = 'XX.DESCRIPTION'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00142988 - S
  fieldName='RTE.POSITION'
  fieldLength='3'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
*PACS00142988 - E

  fieldName='RESERVED.5'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.4'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.3'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.2'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.1'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
