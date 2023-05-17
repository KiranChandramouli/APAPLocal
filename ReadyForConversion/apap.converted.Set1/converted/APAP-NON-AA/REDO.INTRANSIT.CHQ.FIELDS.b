SUBROUTINE REDO.INTRANSIT.CHQ.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.INTRANSIT.LOCK
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009120290
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'XX<TFS.REFERENCE'
    fieldLength = '20'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX-CLEAR.OUT.ID'
    fieldLength = '35'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


    fieldName = 'XX-CHQ.NUMBER'
    fieldLength = '25'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


    fieldName = 'XX-CHQ.AMOUNT'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


    fieldName = 'XX-EXPOSURE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;



    fieldName = 'XX>UTILISED.AMT'
    fieldLength = '35'
    fieldType = 'AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;



*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
