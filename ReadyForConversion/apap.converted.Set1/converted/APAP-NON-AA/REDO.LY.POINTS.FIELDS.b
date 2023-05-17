SUBROUTINE REDO.LY.POINTS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.POINTS.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 05-04-2010      GANESH      ODR-2009-12-0276   INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.LY.POINTS", T24_String)         ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '10'
    ID.T = 'A'
    ID.CHECKFILE='CUSTOMER'

    fieldName='XX<PRODUCT'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CATEGORY")

    fieldName='XX-XX<PROGRAM'
    fieldLength='8'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.PROGRAM")

    fieldName='XX-XX-TXN.ID'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-QUANTITY'
    fieldLength='10'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-QTY.VALUE'
    fieldLength='12'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-STATUS'
    fieldLength='20'
    fieldType=''
    fieldType<2>='Liberada_No.Liberada_Expirada_Pendiente.Someter_Sometida_Utilizada'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-GEN.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-AVAIL.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-EXP.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-MAN.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-MAN.QTY'
    fieldLength='10'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-MAN.QTY.VALUE'
    fieldLength='12'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-MAN.DESC'
    fieldLength='100'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-MAN.STATUS'
    fieldLength='2'
    fieldType=''
    fieldType<2>='SI_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX>XX>MAN.USER'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile("USER")



*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
