$PACKAGE APAP.TAM
SUBROUTINE REDO.L.ALL.FT.TT.FX.IDS.FIELDS
*-----------------------------------------------------------------------------
* COMPANY NAME  : APAP
* DEVELOPED BY  : THENMALAR T
* PROGRAM NAME  : REDO.L.ALL.FT.TT.FX.IDS.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.L.AUTH.COLLATERAL'
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*  CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
    ID.F = '@ID'
    ID.N = '20'
    ID.T = 'A'
    ID.CHECKFILE = ""

*-----------------------------------------------------------------------------

    fieldName = "DATE"
    fieldLength = "12"
    fieldType = "D"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "FT.TXN.TYPE"
    fieldLength = "15"
    fieldType = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


    fieldName = "TT.TXN.TYPE"
    fieldLength = "15"
    fieldType = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "FX.DEAL.TYPE"
    fieldLength = "15"
    fieldType = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "FX.CCY.SOLD"
    fieldLength = "3"
    fieldType = "CCY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = "FX.CCY.BUY"
    fieldLength = "3"
    fieldType = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


*-----------------------------------------------------------------------------
* CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
