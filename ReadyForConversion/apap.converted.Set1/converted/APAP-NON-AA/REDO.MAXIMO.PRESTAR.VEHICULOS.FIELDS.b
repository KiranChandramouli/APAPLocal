SUBROUTINE REDO.MAXIMO.PRESTAR.VEHICULOS.FIELDS
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
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("PRODUCT.GROUP", 35, "A", "")         ;* Add a new field
    CALL Field.setCheckFile("AA.PRODUCT.GROUP")     ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("VEH.USE.TIME", 35, "A", "")          ;* Add a new field
    CALL Table.addFieldDefinition("PERC.MAX.AMT.LOAN", 4, "", "")       ;* Add a new field
    CALL Table.addFieldDefinition("VEH.USE.YEARS", 3, "A", "")          ;* Add a new field

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
