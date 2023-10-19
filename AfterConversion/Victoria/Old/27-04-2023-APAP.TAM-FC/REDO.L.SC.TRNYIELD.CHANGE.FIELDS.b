* @ValidationCode : MjotMTQ0ODkwMjM4NTpDcDEyNTI6MTY4MTIzOTA5MDk2MDpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:30
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
SUBROUTINE REDO.L.SC.TRNYIELD.CHANGE.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.L.SC.TRNYIELD.CHANGE
*---------------------------------------------------------------------------------------
*  Input / Output:
* ---------------
* IN     : -NA-
* OUT    : -NA-
*---------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RIYAS AHAMAD BASHA J
* PROGRAM NAME : REDO.L.SC.TRNYIELD.CHANGE.FIELDS
*---------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                    REFERENCE         DESCRIPTION
* 15.11.2010   RIYAS AHAMAD BASHA J    ODR-2010-07-0083   INITIAL CREATION
* 12.04.2023   Conversion Tool             R22            Auto Conversion     - No changes
* 12.04.2023   Shanmugapriya M             R22            Manual Conversion   - No changes
*
* --------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = 20
    ID.T<1> = 'A'
*-----------------------------------------------------------------------------

    fieldName = 'SECURITY.NO'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'DATE.CHANGE'
    fieldLength = '11'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX<TIME.CHANGE'
    fieldLength = '5'
    fieldType = 'TIME'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX-NEW.YIELD'
    fieldLength = '16'
    fieldType = 'R'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX-OLD.YIELD'
    fieldLength = '16'
    fieldType = 'R'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX>INP.USER'
    fieldLength = '30'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
