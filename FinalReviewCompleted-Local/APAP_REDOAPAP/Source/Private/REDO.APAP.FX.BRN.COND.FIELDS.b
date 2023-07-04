* @ValidationCode : MjoxNTgyMjY1NTY3OkNwMTI1MjoxNjgwNjc1NTUwMjIwOklUU1M6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:49:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.FX.BRN.COND.FIELDS
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for template REDO.APAP.FX.BRN.COND
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                   Reference              Description
* 08-NOV-2010    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
* 24-OCT-2011    Pradeep S             PACS00149084           Two new fields added to store
*                                                             e-mail information
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
*** <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.T = '' ; ID.N = '35' ; ID.F = '@ID' ; ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'FX.POSN'
    fieldLength = '30'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'OVERALL.POSN'
    fieldLength = '16.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'OVR.VALID.DATE'
    fieldLength = '11.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.EMAIL.ID'
    fieldLength = '35'
    fieldType = 'A'
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
    neighbour = ''
    fieldName = 'VERIFY.EXP'
    fieldLength = '2'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour = ''
    fieldName = 'XX.EXP.EMAIL'
    fieldLength = '65.1'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.EXP.BODY'
    fieldLength = '65.1'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour = ''
    fieldName = 'XX.CR.USER.CLASS'
    fieldLength = '65'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.TR.USER.CLASS'
    fieldLength = '65'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
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
