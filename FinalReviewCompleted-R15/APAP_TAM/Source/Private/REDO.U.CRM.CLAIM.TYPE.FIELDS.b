* @ValidationCode : MjotMTUwMjEwMDU5NTpDcDEyNTI6MTY4MTEyMTI1NDIwNzpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:37:34
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
SUBROUTINE REDO.U.CRM.CLAIM.TYPE.FIELDS
*-----------------------------------------------------------------------------
**-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.U.CRM.CLAIM.TYPE.FIELDS
*-----------------------------------------------------------------------------
* * Modification History :
* 03-Feb-2014 - Gangadhar - Added new field L.CLAIM.TYPE for REGN16 - Regulatory report.
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - ! TO *
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
* *-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
*The ID of the Field is validated with the record ID of the Currency Table
*
*              ;** R22 Auto conversion - ! TO *
    ID.N = "35" ; ID.T = "A"
*             ;** R22 Auto conversion - ! TO *
    fieldName         = 'XX.LL.DESCRIPTION'
    fieldLength       = '50.1'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
    fieldName         = 'XX.DOC.REQUIRE'
    fieldLength       = '35'
    fieldType         = 'A'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
    CALL Field.setCheckFile('REDO.U.CRM.DOC.TYPE')
*
* REGN16 - Regulatory report - Start
    fieldName         = 'L.CLAIM.TYPE'
    virtualTableName = 'L.CLAIM.TYPE'
    neighbour         = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)         ;* Specify Lookup values
** REGN16 - Regulatory report - End

*    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
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
*
    fieldName         = 'XX.LOCAL.REF'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
