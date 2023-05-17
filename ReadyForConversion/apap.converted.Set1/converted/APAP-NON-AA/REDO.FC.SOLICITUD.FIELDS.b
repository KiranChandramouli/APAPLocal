SUBROUTINE REDO.FC.SOLICITUD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

    C$NS.OPERATION = 'ALL'
*-----------------------------------------------------------------------------
    ID.F = "FCSOL.ID" ;  ID.N = "35" ;  ID.T = "A"
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition('AMT.SOLICITA', 19, 'AMT', '')

    fieldName = 'FEC.SOLICITA'
    fieldLength = '8'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addFieldDefinition('AMT.PREAPROB', 19, 'AMT', '')

    fieldName = 'FEC.PREAPROB'
    fieldLength = '8'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addFieldDefinition('AMT.FRMNEG', 19, 'AMT', '')

    fieldName = 'FEC.FRMNEG'
    fieldLength = '8'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addFieldDefinition('AMT.APROBADO', 19, 'AMT', '')

    fieldName = 'FEC.APROBADO'
    fieldLength = '8'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ESTATUS'
    fieldLength='15.1'
    fieldType=''
    fieldType<2>="PREAPROBADA_REFERIDA_FORMALIZADA_APROBADA_DECLINADA"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addFieldDefinition('SCORING', 35, '', '')

    neighbour = ''
    fieldName = 'CUSTOMER'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*-----------------------------------------------------------------------------

    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
