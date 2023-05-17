SUBROUTINE REDO.FXSN.TXN.VERSION.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FXSN.TXN.VERSION *
* @author tchandru@temenos.com
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
* Date             Author             Reference         Description
* 04-May-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID",T24_String) ;* Define Table id
    ID.F = '@ID'
    ID.N = '15'
    ID.T = ''
    ID.T<2> = 'SYSTEM'
*------------------------------------------------------------------------------
    fieldName = 'DESCRIPTION'
    fieldLength = '50'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX<T24.TXN.DESC'
    fieldLength = '50.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX>VERSION.NAME'
    fieldLength = '50.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('VERSION')

    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName = 'XX.STMT.NOS'
    fieldLength = '50'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
