* @ValidationCode : MjoxNjkzMTQzODAxOkNwMTI1MjoxNjgxMjM5MDkxMDI5OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:31
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
SUBROUTINE REDO.LOAN.ACCOUNT.STATUS.FIELDS

*<doc>
* Template for field definitions routine REDO.LOAN.ACCOUNT.STATUS
*
* @author
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 17/8/2011      Ravikiran                          Creation
* 12.04.2023    Conversion Tool    R22            Auto Conversion     - No changes
* 12.04.2023    Shanmugapriya M    R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

    GOSUB INITIALISE

    GOSUB FIELD.DEFINITION

RETURN

INITIALISE:

    LOAN.STATUS = ""
    LOAN.STATUS = "L.LOAN.STATUS.1"
    CALL EB.LOOKUP.LIST(LOAN.STATUS)
    CHANGE @FM TO @VM IN LOAN.STATUS

RETURN

FIELD.DEFINITION:

    ID.F = 'LOAN.STATUS'
    ID.N = '35'
    ID.T = 'A'

    fieldName = 'CONSOL.KEY.VAL'
    fieldLength = '3'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.addField("RESERVED.5",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.4",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.3",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.2",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.1",  T24_String, Field_NoInput,"");

    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
