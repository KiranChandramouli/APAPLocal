* @ValidationCode : MjotMTk1MDM3Mzk3NzpDcDEyNTI6MTY4MTIxMDEzNDIxODpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:18:54
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
SUBROUTINE REDO.H.REPORTS.PARAM.FIELDS
*----------------------------------------------------------------------------------------------------------------
*
* Description           : Fields for REDO.H.REPORTS.PARAM table defined here
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : N/A
*
* Attached As           : .FIELDS Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*                        Krishnaveni G                   2013-10-17          New field added to capture Temporary directory
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
*<doc>
* @author-> saranraj.subramani@capgemini.com
* </doc>
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)
    ID.F = "@ID"
    ID.N = "35.1"
    ID.T = "A"
*-----------------------------------------------------------------------------
    fieldName   = 'DESCRIPTION'
    fieldLength = '65'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'XX.OUT.DIR'
    fieldLength = '50'
    fieldType   = 'ANY'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'OUT.FILE.NAME'
    fieldLength = '35'
    fieldType   = 'ANY'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'INFO.CODE'
    fieldLength = '6'
    fieldType   = ''
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'APAP.ID'
    fieldLength = '15'
    fieldType   = ''
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'FREQUENCY.REQ'
    CALL Table.addOptionsField(fieldName,"Yearly_Monthly", "", "")

    fieldName   = 'YEAR.MONTH'
    fieldLength = '10'
    fieldType   = ''
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'INT.ACCT.NO'
    fieldLength = '16'
    fieldType   = 'INT'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = "XX<FIELD.NAME"
    fieldType = 'A'
    fieldLength = 50
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "XX-XX<FIELD.VALUE"
    fieldType = 'A'
    fieldLength = 50
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "XX>XX>DISPLAY.TEXT"
    fieldType = 'A'
    fieldLength = 80
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
* (S) 20131017  new field added to capture temporary directory instead of REDO.REPORT.TEMP file
    fieldName = "XX.TEMP.DIR"
    fieldType = 'A'
    fieldLength = 65
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*-----------------------------------------------------------------------------
    II = 9
* (E) 20131017
    Y.RESERVED.FIELD = ''
    Y.RESERVED.FIELD = "RESERVED."
    LOOP
    WHILE II GE 1
        CALL Table.addReservedField(Y.RESERVED.FIELD:II)
        II -= 1
    REPEAT
*
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
