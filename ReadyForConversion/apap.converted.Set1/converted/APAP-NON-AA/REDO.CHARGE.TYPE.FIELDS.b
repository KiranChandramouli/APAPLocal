SUBROUTINE REDO.CHARGE.TYPE.FIELDS
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
    CALL Table.defineId("REDO.CHARGE.TYPE", T24_String)       ;* Define Table id
    ID.F=""
    ID.N="6"
    ID.T=""
    ID.T<2> ='SYSTEM'

*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("CHARGE.TYPE","15","A","")
    CALL Field.setCheckFile('FT.COMMISSION.TYPE')
    CALL Table.addFieldDefinition("CHARGE.AMOUNT","6","A","");

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
