SUBROUTINE REDO.FC.ENQPARMS.FIELDS
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
*-----------------------------------------------------------------------------
    CALL Table.defineId("ENQPARMS.ID", T24_String)  ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addField("APLICACION", T24_String , "", "")    ;* Add a new fields
    CALL Field.setCheckFile('PGM.FILE')
    CALL Table.addField("XX<CATEG.INI", T24_Numeric , "", "")
    CALL Table.addField("XX>CATEG.FIN", T24_Numeric , "", "")
    CALL Table.addField("XX<CAMPO", T24_String , "", "")
    CALL Table.addField("XX>RUTINA", T24_String , "", "")
*-----------------------------------------------------------------------------
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
*-----------------------------------------------------------------------------


    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
