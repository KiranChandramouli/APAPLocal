SUBROUTINE REDO.CUSTOMER.PARAM.FIELDS

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.CUSTOMER.PARAM.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.CUSTOMER.PARAM.FIELDS
*LINKED WITH    :REDO.CUSTOMER.PARAM.FIELDS
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*-------------------------------------------------------------------------
*ODR-2010-08-0031   Prabhu N  initial draft
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


    ID.F='CUSTOMER'
    ID.T=''

*-------------------------------------------------------------------------
    fieldName="CUSTOMER.NAME"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="AC.ENTRY.PARAM"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.setAuditPosition
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
