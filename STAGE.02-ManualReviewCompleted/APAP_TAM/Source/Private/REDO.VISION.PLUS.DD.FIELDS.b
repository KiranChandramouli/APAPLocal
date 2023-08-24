* @ValidationCode : MjoxNjQwNzgxNjgwOkNwMTI1MjoxNjgxMTkzOTMzODg1OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:53
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
SUBROUTINE REDO.VISION.PLUS.DD.FIELDS
*<doc>
* Template for field definitions for the application REDO.VISION.PLUS.PARAM
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour    = ''
    fieldName    = 'NOMBRE'
    fieldLength  = '40'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'NUMERO.CUENTA'
    fieldLength  = '19'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'NUM.CTA.AHORRO'
    fieldLength  = '19'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'TIPO.PAGO.SENAL'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MONTO.PAGO'
    fieldLength  = '17.2'
    fieldType    = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'FECHA.LIM.PAGO'
    fieldLength  = '8'
    fieldType    = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addOptionsField("PROCESADO","OK_ERROR_PEND","","")

    neighbour    = ''
    fieldName    = 'OBSERVACIONES'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'TXN.REF'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('XX-RESERVED.5')
    CALL Table.addReservedField('XX-RESERVED.4')
    CALL Table.addReservedField('XX-RESERVED.3')
    CALL Table.addReservedField('XX-RESERVED.2')
    CALL Table.addReservedField('XX>RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Populate audit information

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
