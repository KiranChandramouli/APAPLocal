SUBROUTINE REDO.H.TAX.DATA.CHECKS.FIELDS
*----------------------------------------------------------------------------------------------------------------
*
* Description           : Fields for the table REDO.H.TAX.DATA.CHECKS defined here
*
* Developed By          : Thilak Kumar.K
*
* Development Reference : RegN11
*
* Attached To           : N/A
*
* Attached As           : .FIELDS Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
*<doc>
* @author-> thilak-kumar.kumaresan@capgemini.com
* </doc>
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    ID.F = "@ID"
    ID.N = "6"
    ID.T = "":@FM:"SYSTEM"
*-----------------------------------------------------------------------------
    fieldName   = 'DATE.FROM'
    fieldLength = '8'
    fieldType   = 'D'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName   = 'DATE.TO'
    fieldLength = '8'
    fieldType   = 'D'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    CALL Table.addOptionsField("REPORT.GEN","YES_NO","","")
*
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*------------
END
