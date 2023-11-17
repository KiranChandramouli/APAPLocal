$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.IBSOLUTION.USER.FIELDS
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
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("LOGIN", T24_String)  ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("NAME", T24_String, Field_Mandatory, "")   ;* Add a new fields
    CALL Table.addField("STATUS", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("LAST.LOGIN", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("XX-OLD.PASSWORD", T24_String, "", "")      ;* Has "UserId,TokenId"
    CALL Table.addField("RESERVED.8", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.7", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.6", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.5", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.4", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.3", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.2", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("RESERVED.1", T24_String, "", "")   ;* Add a new fields



*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
