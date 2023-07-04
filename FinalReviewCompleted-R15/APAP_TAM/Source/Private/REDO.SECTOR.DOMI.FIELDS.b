* @ValidationCode : MjotMTg3MTQ0ODAyNTpDcDEyNTI6MTY4MTA1NjQ4NTk4MzpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
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
SUBROUTINE REDO.SECTOR.DOMI.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACI POPULAR DE AHORROS Y PRTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.SECTOR.DOMI.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID",T24_String)
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)
* CALL Field.setCheckFile(fileName)

    CALL Table.addFieldDefinition("XX.DESCRIPTION", "35.1", "A", "")
    CALL Table.addFieldDefinition("XX.SHORT.NAME", "35.1", "A", "")
    CALL Table.addField("XX.LOCAL.REF", T24_String,"","")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput ,"")

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
* CALL Field.setDefault(defaultValue)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
