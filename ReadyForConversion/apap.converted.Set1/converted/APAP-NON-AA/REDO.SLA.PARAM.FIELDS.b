SUBROUTINE REDO.SLA.PARAM.FIELDS
*-----------------------------------------------------------------------------
**-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : B.Renugadevi
* PROGRAM NAME : REDO.SLA.PARAM.FIELDS
*-----------------------------------------------------------------------------
* * Modification History :
*   DATE             WHO            REFERENCE         DESCRIPTION
* 10-05-2011      Pradeep S         PACS00060849      Added checkfile for claim type
* 15-09-2011      Sudharsanan S     PACS00126457      Added EB.LOOKUP for START.CHANNEL
* *-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
*The ID of the Field is validated with the record ID of the Currency Table
*
*
    ID.N = "36" ; ID.T = "A"
*
    fieldName         = 'XX<DESCRIPTION'
    fieldLength       = '35.1'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.U.CRM.CLAIM.TYPE')          ;* PACS00060849 - S/E
*
    fieldName         = 'XX-XX.DOC.REQUIRE'
    fieldLength       = '35'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.U.CRM.DOC.TYPE')  ;* PACS00060849 - S/E
*
    fieldName         = 'XX-RISK.LEVEL'
    fieldLength       = '6'
    fieldType         = "A"
    neighbour         = ''
    virtualTableName='SLA.RISK.LEVEL'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*
    fieldName         = 'XX-SUPPORT.GROUP'
    fieldLength       = '35'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile("PW.PARTICIPANT")
*
    fieldName         = 'XX-XX<START.CHANNEL'
    fieldLength       = '35'
    fieldType         = "A"
    neighbour         = ''
    virtualTableName='START.CHANNEL'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*
    fieldName         = 'XX>XX>SEG.DAYS'
    fieldLength       = '4'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*
    fieldName         = 'XX.OVERRIDE'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName         = 'XX.STMT.NOS'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName         = 'XX.LOCAL.REF'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
