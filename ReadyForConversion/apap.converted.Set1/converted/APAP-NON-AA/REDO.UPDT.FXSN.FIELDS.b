SUBROUTINE REDO.UPDT.FXSN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.UPDT.FXSN *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-01-0213
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
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
    ID.N = '10'
    ID.T = ''
*------------------------------------------------------------------------------
    fieldName = 'SPECIFY.NO.REC'
    fieldLength = '10'
    fieldType = 'A'
*    fieldType = "":FM:"Available_Issued_Cancelled"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
