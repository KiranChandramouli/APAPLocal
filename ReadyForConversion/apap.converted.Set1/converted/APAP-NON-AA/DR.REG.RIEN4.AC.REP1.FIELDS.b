*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AC.REP1.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.RIEN4.AC.REP1.FIELDS
*-----------------------------------------------------------------------------
*Description       :Table will hold the file details
*In  Parameter     : N/A
*Out Parameter     : N/A
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    ID.F = '@ID'  ;  ID.N= '20' ;ID.T = 'A'         ;* Included fields type

    fieldName="INT.RATE"
    fieldLength='19'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="ONLINE.ACT.BAL"
    fieldLength='20'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CATEGORY"
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="TOTAL"
    fieldLength='20'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*

*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
