SUBROUTINE REDO.H.FT.CONCAT.FILE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.H.PART.PAY.FT.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009110157
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
    ID.N = '25'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'NO.OF.PAYMENTS'
    fieldLength = '5'
    fieldType = ''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
