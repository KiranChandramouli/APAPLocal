SUBROUTINE REDO.RISK.GROUP.FIELDS

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.RISK.GROUP.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.RISK.GROUP
*LINKED WITH    :REDO.RISK.GROUP
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes




    ID.F='RISK.GRP.CODE'
    ID.N='0010.1'
    ID.T='ANY'

*-------------------------------------------------------------------------
    fieldName="XX.RISK.GRP.DESC"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.GRP.SHORT.DESC"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.setAuditPosition
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
