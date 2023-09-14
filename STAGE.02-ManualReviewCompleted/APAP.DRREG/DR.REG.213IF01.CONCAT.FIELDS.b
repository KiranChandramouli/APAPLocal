* @ValidationCode : Mjo0ODQ0NjUyMjE6Q3AxMjUyOjE2ODA2MDg1MzczMzU6YWppdGg6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:12:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.213IF01.CONCAT.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification      REFERENCE                Description
* 11-Aug-2014     V.P.Ashokkumar      PACS00309079 -                           Updated the field mapping and format
* 14-Oct-2014     V.P.Ashokkumar      PACS00309079 -                           Updated to filter AML transaction
*04-04-2023     CONVERSION TOOLS                    AUTO R22 CODE CONVERSION     NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION       NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Report IF01 - Concat table
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------

    ID.F = "CUST.DATE" ; ID.N = "25.1" ; ID.T = "A"

    neighbour = ""
    fieldName = "XX.STMT.ID" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "CR.AMOUNT" ;  fieldLength = "19" ; fieldType = "AMT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "CR.DATE" ;  fieldLength = "8" ; fieldType = "D"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "CUST.RELATION" ;  fieldLength = "4" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "CUST.RTE.FORM" ;  fieldLength = "3" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.PEP.STMT.ID" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    CALL Table.addField ("RESERVED.05", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.04", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.03", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.02", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.01", "", Field_NoInput, "")
*-----------------------------------------------------------------------------
*  CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*    CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
