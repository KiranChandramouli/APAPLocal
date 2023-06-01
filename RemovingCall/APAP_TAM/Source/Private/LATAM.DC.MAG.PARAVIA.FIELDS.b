* @ValidationCode : MjotODk4OTYwMTcyOkNwMTI1MjoxNjgwNjEwNzQ4MDE0OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:49:08
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
SUBROUTINE LATAM.DC.MAG.PARAVIA.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO           REFERENCE          DESCRIPTION
* 08-02-2010    Akthar Rasool S  ODR-2010-08-0469   INITIAL CREATION
*
*04.04.2023    Conversion Tool      R22               Auto Conversion     - No changes
*04.04.2023    Shanmugapriya M      R22               Manual Conversion   - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("LATAM.DC.MAG.PARAVIA", T24_String)   ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '6'
    ID.T = ''   ; ID.T<2> = 'SYSTEM'

    fieldName='ISO.FIELD.POS'
    fieldLength='3.1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ISO.VALUE'
    fieldLength='4.1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ISO.FLD.ACCEPTOR'
    fieldLength='3.1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX<MAGUANA.PARAVIA'
    fieldLength='8.1'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX>DESCRIPTION'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='FTTC.ID'
    fieldLength='4.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")


    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")




    CALL Table.addOverrideField


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
