*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.IVR.PARAMS.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the REDO.IVR.PARAMS
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
*  28-JUN-2010  SWAMINATHAN.S.R         ODR-2009-12-0287       INITIAL VERSION
*  10-OCT-2011   RMONDRAGON             ODR-2009-12-0287       UPDATE FOR FIELDS NOT
*                                                              NEEDED
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*-----------------------------------------------------------------------------
*    CALL Table.defineId("REDO.IVR.PARAMS", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID' ; ID.N = '6'
  ID.T = "A"   ;

  neighbour = ''
  fieldName = 'USER'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'PWD'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'APP.ENQ'
  fieldLength = '100'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.APP.MAP'
  fieldLength = '100'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
