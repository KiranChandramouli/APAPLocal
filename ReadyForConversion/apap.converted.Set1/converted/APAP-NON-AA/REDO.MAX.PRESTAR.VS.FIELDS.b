SUBROUTINE REDO.MAX.PRESTAR.VS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.MAXIMO.PRESTAR.VS.FIELDS
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

    CALL Table.addFieldDefinition("PRODUCT.GROUP", 35, "A", "")
    CALL Field.setCheckFile("AA.PRODUCT.GROUP")
    CALL Table.addOptionsField("VEH.TYPE","NUEVO_USADO","","")
    CALL Table.addFieldDefinition("VEH.USE.DESC", 35, "A", "")
    CALL Table.addFieldDefinition("VEH.USE.FROM", 3, "A", "")
    CALL Table.addFieldDefinition("VEH.USE.TO", 3, "A", "")
    CALL Table.addFieldDefinition("PERC.MAX.AMT.LOAN", 4, "", "")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
