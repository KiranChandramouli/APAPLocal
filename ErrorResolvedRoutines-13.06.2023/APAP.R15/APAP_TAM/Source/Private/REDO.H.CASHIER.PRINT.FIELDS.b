* @ValidationCode : MjotMTg4MDQ5ODIyOTpDcDEyNTI6MTY4Mzg5MjYzMzA5NzpJVFNTMTotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.CASHIER.PRINT.FIELDS

*----------------------------------------------------------------------------------------------------------------------
* Revision History
*----------------------------------------------------------------------------------------------------------------------
* Date          Developed By          Reference        Description
* 31/07/2013    Vignesh Kumaar M R    PACS00305984     CASHIER DEAL SLIP PRINT OPTION
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

* ID definition
    CALL Table.defineId("RECORD.ID", T24_String)
    ID.T<1> = '' ; ID.T<2> = 'SYSTEM'

* Normal fields
    neighbour = '' ;
    fieldName = 'XX<VERSION.NAME' ; fieldLength = '54' ; fieldType = 'A' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile('VERSION')
    fieldName = 'XX-XX.SLIP.ID' ; fieldLength = '15' ; fieldType = 'A' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile('DEAL.SLIP.FORMAT')
    fieldName = 'XX-PRINT' ; fieldLength = '2' ; fieldType = '':@FM:'SI_NO' ; GOSUB ADD.FIELDS
    fieldName = 'XX-RESERVED.7' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'XX-RESERVED.6' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'XX>REPRINT' ; fieldLength = '2' ; fieldType = '':@FM:'SI_NO' ; GOSUB ADD.FIELDS

* Reserved fields

    fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

* Local reference field

    fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = T24_String ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

*override field

    fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*override field

    fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

* Audit fields
    GOSUB ADD.AUDIT.FIELDS

RETURN
*-----------------------------------------------------------------------------

ADD.FIELDS:
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
RETURN

ADD.RESERVED.FIELDS:
    CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

ADD.LOCAL.REF.FIELDS:
    CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

ADD.AUDIT.FIELDS:
    CALL Table.setAuditPosition
RETURN

*-----------------------------------------------------------------------------

END
* End of Subroutine
