SUBROUTINE REDO.APAP.FX.BRN.POSN.FIELDS
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for template REDO.APAP.FX.BRN.POSN
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                   Reference              Description
* 08-NOV-2010    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
* 24-OCT-2011    Pradeep S             PACS00149084           Two new fields added to store
*                                                             e-mail information
*-----------------------------------------------------------------------------
*** <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.T = 'A' ; ID.N = '35' ; ID.F = '@ID' ; ID.CHECKFILE = 'COMPANY'
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'TOT.BRN.LIMIT'
    fieldLength = '30.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BRN.TDY.TXN.VALUE'
    fieldLength = '30'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.MAIL.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BRN.LIM.VALID.DATE'
    fieldLength = '11.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
*PACS00149084 - S
*CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
*CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")

    neighbour = ''
    fieldName = 'XX.EMAIL.SUBJECT'
    fieldLength = '65.1'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.EMAIL.BODY'
    fieldLength = '65.1'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00149084 - E
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*-----------------------------------------------------------------------------

    CALL Table.addLocalReferenceField(XX.LOCAL.REF)

    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
