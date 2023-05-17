SUBROUTINE CRR.CARD.AGREEMENT.FIELDS
*-----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------
*COMPANY NAME: APAP
*DEVELOPED BY: Temenos Application Management
*------------------------------------------------------------------------------------------
* DESCRIPTION:
*    This is field definition routine for local templates CRR.EB.WEB.EMBOSS
*    All field attributes should be defined here
*------------------------------------------------------------------------------------------
* Modification History :
* DATE             WHO         REFERENCE         DESCRIPTION
*07-July-2010     MANJU     ODR-2009-12-0264   INITIAL CREATION
*-----------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("CRR.CARD.AGREEMENT",T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = 'ID' ; ID.N = '7'
    ID.T = 'A'

    fieldName='DESCRIPTION'
    fieldLength='50'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='EMBOSS.AGREE'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='XX.LOCAL.REF'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='XX.OVERRIDE'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*---------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
