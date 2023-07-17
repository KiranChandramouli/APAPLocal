* @ValidationCode : MjoxMDc3NDMzNTU2OkNwMTI1MjoxNjg0ODU0NDAzMjQwOklUU1M6LTE6LTE6LTMyOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -32
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B2.FT.PARAMETERS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.B2.FT.PARAMETERS.FIELDS *
* @author ejijon@temenos.com
* @stereotype fields template
* @uses Table
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'

*------------------------------------------------------------------------------
*
*
* fieldName = 'XX<POLICY.TYPE'
* fieldLength = '35'
* fieldType = 'A'
* neighbour = ''
* CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
* CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")

    fieldName = 'XX<CLASS.POLICY'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")

    fieldName = 'XX-XX<INS.COMPANY'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("REDO.APAP.H.COMP.NAME")

    fieldName = 'XX-XX-PRIMA.NETA'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-COMISION.APAP'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-ITBIS'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.PRIMA.NETA'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.COMISION.APAP'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.ITBIS'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.MONTO.BASE'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.BRUTO'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-DES.NETO'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-FHA.PERCENTAGE'
    fieldLength = '3'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX-XX-FECHA.CORTE'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'XX>XX>ID.DESEMBOLSOS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('AA.PRD.DES.PAYMENT.RULES')
*
*    fieldName = 'XX.CHARGE.TYPE'
*    fieldLength = '35'
*    fieldType = 'A'
*    neighbour = ''
*    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*    CALL Field.setCheckFile('FT.CHARGE.TYPE')
*
    fieldName = 'PL.COMMISSION'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("CATEGORY")

    fieldName = 'TAX.INT.AC'
    fieldLength = '20'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'FHA.INT.AC'
    fieldLength = '20'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'ORIG.COM.PERC'
    fieldLength = '20'
    fieldType = 'AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    CALL Table.addReservedField("RESERVED.2")
    CALL Table.addReservedField("RESERVED.1")

    CALL Table.addLocalReferenceField(XX.LOCAL.REF)
    CALL Table.addOverrideField

*
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
