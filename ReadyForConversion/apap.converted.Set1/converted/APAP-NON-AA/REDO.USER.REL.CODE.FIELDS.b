SUBROUTINE REDO.USER.REL.CODE.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the REDO.USER.REL.CODE
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
* Date            Who                    Reference             Description
* 09-JUL-2009  KARTHI.KR(TEMENOS)        ODR-2009-06-0219      INITIAL VERSION
* 05-05-2011   GANESH H                  PACS00023889          MODIFICATION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*   CALL Table.defineId("REDO.USER.REL.CODE", T24_String)   ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = "USER.REL.CODE" ;  ID.N = "3" ;  ID.T = ""

    fieldName = 'XX.REL.DESC'
    fieldLength = '35'
*PACS00023889-S
    fieldType = 'ANY'
*PACS00023889-E
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
