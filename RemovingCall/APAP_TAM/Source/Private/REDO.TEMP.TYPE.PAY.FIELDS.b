* @ValidationCode : MjoxNTI0MDcwMTEyOkNwMTI1MjoxNjgxMDk3NzM0MzgwOklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 09:05:34
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
SUBROUTINE REDO.TEMP.TYPE.PAY.FIELDS
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = 30
    ID.T = 'A'
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
*CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName = 'XX<TYPE.PAYMENT'
    fieldLength = '10'
    fieldType<1> = ''
    fieldType<2> = 'EFFECTIVO_CHEQUE'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX>TXN.REFERENCE'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
