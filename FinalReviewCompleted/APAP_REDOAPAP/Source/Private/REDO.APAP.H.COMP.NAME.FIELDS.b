* @ValidationCode : MjotMzE3NTkzMTY2OkNwMTI1MjoxNjg0ODM2MDQxMjMyOklUU1M6LTE6LTE6LTk6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.H.COMP.NAME.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.APAP.H.COMP.NAME.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009100340
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*
* 22/06/11 - CR010 - pgarzongavilanes@temenos.com
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'INS.COMP.NAME'
    fieldLength = '50.1'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'XX<CLASS.POLICY'
    fieldLength = '35'
    neighbour = ''
    fieldType='A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")
*
    fieldName = 'XX-INS.POLICY.TYPE'
    fieldLength = '35'
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")
*
    fieldName = 'XX-SEN.POLICY.NUMBER'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'XX>MAX.POLICY.NUMBER'
    fieldLength = '35'
    fieldType = ""
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    CALL Table.addReservedField("RESERVED.5")
    CALL Table.addReservedField("RESERVED.4")
    CALL Table.addReservedField("RESERVED.3")
    CALL Table.addReservedField("RESERVED.2")
    CALL Table.addReservedField("RESERVED.1")

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
