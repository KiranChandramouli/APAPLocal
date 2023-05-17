SUBROUTINE REDO.CH.PINADM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CH.PINADM.FIELDS
*
* @author rmondragon@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*
* 1/11/10 - First Version
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("USER.ID", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("PIN", T24_String, "", "")
    CALL Table.addField("START.DATE", T24_Date, "", "")
    CALL Table.addField("START.TIME", T24_String, "", "")
    CALL Table.addOptionsField("TYPE", "TEMPORAL_DEFINITIVO", "", "")
*-----------------------------------------------------------------------------
*   CALL Table.addLocalReferenceField
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
