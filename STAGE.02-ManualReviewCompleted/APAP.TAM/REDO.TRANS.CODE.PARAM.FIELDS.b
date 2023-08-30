* @ValidationCode : MjotMTk5NzE4MzA5OTpDcDEyNTI6MTY4MTg4OTE5MjIzNTpzYW1hcjotMTotMTowOjA6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:56:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TRANS.CODE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* Date               who           Reference            Description
* 11-Apr-2011        Pradeep S     PACS00052995         Changed the value from CASH to EFECTIVO
*                                                       for the field TRAN.TYPE
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                          FM TO @FM
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F="@ID"
    ID.N="6"
    ID.T=""
    ID.T<2>="SYSTEM"
*-----------------------------------------------------------------------------
    fieldName="XX<TRANS.CODE"
    fieldLength="8.1"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('TELLER.TRANSACTION')

    fieldName ="XX-TRAN.TYPE"
    fieldLength ="10.1"
* fieldType="":FM:"CASH_CHEQUE"
    fieldType="":@FM:"EFECTIVO_CHEQUE"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="XX-DR.ACCT.NO"
    fieldLength ="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName ="XX>CR.ACCT.NO"
    fieldLength ="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName ="ACTIVATION.KEY"
    fieldLength ="35"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DELIMITER'
    fieldLength = '5'
    fieldType = "ANY"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.14'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.13'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.12'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.11'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.10'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.9'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.8'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.7'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.6'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.5'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.4'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.3'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.2'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'RESERVED.1'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName ="XX.LOCAL.REF"
    fieldLength ="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
END
