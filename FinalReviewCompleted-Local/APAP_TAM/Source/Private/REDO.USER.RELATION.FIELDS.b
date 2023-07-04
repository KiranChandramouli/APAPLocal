$PACKAGE APAP.TAM
SUBROUTINE REDO.USER.RELATION.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the 'REDO.USER.RELATION
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
* 10-AUG-2010  SUJITHA.S                 ODR-2009-06-0219      Modified the field REDO.EMP.CODE
* 06-DEC-2010  SUJITHA.S                 ODR-2009-06-0219      Fields made mandatory
** 18-04-2023 R22 Auto Conversion no changes
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*    CALL Table.defineId("REDO.USER.RELATION", T24_String)   ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = "@ID" ;  ID.N = "35" ;  ID.T = "A"   ; ID.CHECKFILE = 'USER'

    neighbour = ''
    fieldName = 'REDO.EMP.CODE'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<REDO.RELATED.USER'
    fieldLength = '30.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("USER")

    fieldName = 'XX>REDO.RELATION.CODE'
    fieldLength = '30.1'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.USER.REL.CODE")

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
