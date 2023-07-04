* @ValidationCode : MjotMTQ0NjUyMDc1NDpDcDEyNTI6MTY4MTgwMDQ3NTU1MTphaml0aDotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:17:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.PROPERTY.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*DATE           WHO           REFERENCE         DESCRIPTION
*18.11.2010  H GANESH      ODR-2010-03-0176    INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '30'
    ID.T = 'A' ; ID.CHECKFILE='AA.PRODUCT.GROUP'


    fieldName='PENALTY.ARREAR'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")

    fieldName='XX.PRIN.DECREASE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")


    fieldName='BAL.MAIN.PROPERTY'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")

    fieldName='XX.PAYOFF.ACTIVITY'
    fieldLength='55'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.ACTIVITY")

    fieldName='XX.INS.COMM.FIXED'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")

    fieldName='XX.INS.COMM.VARIABLE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")

    fieldName='XX.ENDORSE.COMM'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")

    fieldName        = 'PENALTY.AGE'
    virtualTableName = 'AA.OVERDUE.STATUS'
    neighbour        = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='XX.PAYOFF.ACT.UNC'
    fieldLength='55'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.ACTIVITY")

    fieldName='XX.OVERPAYMENT.TYPE'
    fieldLength='55'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PAYMENT.TYPE")

*CALL Table.addReservedField('RESERVED.9')
*CALL Table.addReservedField('RESERVED.8')
*CALL Table.addReservedField('RESERVED.7')
*CALL Table.addReservedField('RESERVED.6')
*CALL Table.addReservedField('RESERVED.5')
*CALL Table.addReservedField('RESERVED.4')
*CALL Table.addReservedField('RESERVED.3')
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
