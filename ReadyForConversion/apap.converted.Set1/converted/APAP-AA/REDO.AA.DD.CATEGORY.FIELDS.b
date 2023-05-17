SUBROUTINE REDO.AA.DD.CATEGORY.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used to define id and fields for the table REDO.AA.DD.CATEGORY
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 31-10-2017          Edwin Charles  PACS00625972         Initial Creation
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
*
    neighbour = ''
    fieldName = 'XX<FROM.CATEGORY'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("CATEGORY")

    neighbour = ''
    fieldName = 'XX>TO.CATEGORY'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("CATEGORY")

    CALL Table.setAuditPosition         ;* Poputale audit information

RETURN
END
