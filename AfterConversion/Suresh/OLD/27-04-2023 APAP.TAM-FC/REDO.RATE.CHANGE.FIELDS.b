* @ValidationCode : MjoxMzEyODg4NDkyOkNwMTI1MjoxNjgxMDU2NDg1MDQzOklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RATE.CHANGE.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
* 10.04.2023    Conversion Tool           R22                    Auto Conversion     - No changes
* 10.04.2023    Shanmugapriya M           R22                    Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '30'
    ID.T = ''

    fieldName='PRODUCT.GROUP'
    fieldLength='35.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.PRODUCT.GROUP")

    fieldName='XX.PRODUCT'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.PRODUCT")

    fieldName='XX<CAMPAIGN.TYPE'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.CAMPAIGN.TYPES')

    fieldName         = 'XX-XX<AFFIL.COMP'
    fieldLength       = '30'
    fieldType         = 'ANY'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.AFFILIATED.COMPANY')

    fieldName         = 'XX>XX>MARGIN.ID'
    fieldLength       = '10.1'
    fieldType         = ''
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.RATE.CHANGE.CRIT')

    fieldName         = 'BY.DEFAULT'
    fieldLength       = '10'
    fieldType         = ''
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.RATE.CHANGE.CRIT')


    fieldName         = 'FROM.DATE'
    fieldLength       = '10'
    fieldType         = 'D'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

    fieldName         = 'TO.DATE'
    fieldLength       = '10'
    fieldType         = 'D'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

    fieldName         = 'EXTRACT.TYPE'
    neighbour         = ''
    virtualTableName  = 'L.AA.REV.FORM'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='FILE.TYPE'
    fieldLength='35.1'
    fieldType=''
    fieldType<2> = 'MASSIVE_REPLACE_EXTRACT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STATUS'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REPLACE.OPTION'
    fieldLength='35'
    fieldType=''
    fieldType<2>='REPLACE_SUMUP'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
