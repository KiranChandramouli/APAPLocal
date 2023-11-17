$PACKAGE APAP.TAM
SUBROUTINE REDO.LETTER.ISSUE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LETTER.ISSUE.FIELDS
*
* @author nareshc@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 18-03-2010      GANESH      ODR-2009-10-0838   INITIAL CREATION
*
** 12-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    C$NS.OPERATION = 'ALL'
*    CALL Table.defineId("REDO.LETTER.ISSUE", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = 'RECORD.ID'
    ID.N = '16'
    ID.T = 'A'

    fieldName = 'CUSTOMER.ID'
    fieldLength = '10.1'
    fieldType = ''
    fieldType<9>='HOT.FIELD'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CUSTOMER")

    fieldName = 'CU.IDENTITY'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CU.NAME'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'AGENT.NAME'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TYPE.OF.LETTER'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    virtualTableName='TYPE.OF.LETTER'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName = 'XX<PRODUCTS'
    fieldLength = '35.1'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>CUST.HOLD.STATUS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CHARGE.KEY'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.COMMISSION.TYPE")

    fieldName = 'CHARGE.CCY'
    fieldLength = '3'
    fieldType = 'CCY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName = 'CHARGE.AMT'
    fieldLength = '14'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CHARGE.LIQ.ACT'
    fieldLength = '14'
    fieldType = ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName = 'WAIVE.CHARGES'
    fieldLength = '3'
    fieldType = '':@FM:'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'ISS.OFFICER'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<9>='HOT.FIELD'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.OFFICERS.LIST")

    fieldName = 'DESIGNATION'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'BRANCH'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ISSUE.DATE'
    fieldLength = '35'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'START.DATE'
    fieldLength = '35'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'END.DATE'
    fieldLength = '35'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RECIPIENT'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RECIPIENT.CITY'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("RESERVED.5",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.4",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.3",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.2",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.1",  T24_String, Field_NoInput,"");

    neighbour = ''
    fieldName = 'XX.STMT.NO'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
