* @ValidationCode : MjotMTA3NzEzNTkyODpDcDEyNTI6MTY4MDYwMjQ4MDk1NzpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:31:20
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
SUBROUTINE REDO.CASHIER.ROLES.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for local template REDO.CASHIER.ROLES
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date             Who                 Reference           Description
* 16-DEC-2009      Ganesh.R                                INITIAL VERSION
** 04-04-2023 R22 Auto Conversion – FM TO @FM, VM to @VM, SM to @SM
** 04-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
* CALL Table.defineId("CRR.ASSET.ORIGIN", T24_String)     ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '8' ; ID.T = 'A'



    neighbour = ''
    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName ="RESERVED.1"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.2"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.3"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.4"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.5"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.6"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.7"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.8"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.9"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.10"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.11"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.12"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.13"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.14"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.15"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.LOCAL.REF"
    fieldLength ="35"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.STMT.NO"
    fieldLength ="90"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.OVERRIDE"
    fieldLength ="75"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
END
