$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.EXCEP.REC.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ISSUE.DEPT.CODE.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-01-0213
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
* Date             Author             Reference         Description
* 05-APR-2010      Sudharsanan S    PACS00038166  Initial creation
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*ID.N = '35'    ; ID.T = '':FM:'SYSTEM'

    ID.F = '@ID'
    ID.N = '6'
    ID.T = '':@FM:'SYSTEM'
*------------------------------------------------------------------------------
    fieldName = 'DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX.APPLICATION.NAME'
    fieldLength = '65'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*    CALL Field.setCheckFile("STANDARD.SELECTION")

    fieldName = 'XX.RBHP.APPS'
    fieldLength = '65'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX.DEPT.CODES'
    fieldLength = '65'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile("REDO.ISSUE.DEPT.CODE")

    fieldName = 'XX.GENERIC.USER'
    fieldLength = '65'
    fieldType = 'AA'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile("USER")

*CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
