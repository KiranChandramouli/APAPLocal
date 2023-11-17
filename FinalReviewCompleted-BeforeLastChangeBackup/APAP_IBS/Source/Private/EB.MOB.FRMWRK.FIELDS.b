$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-28</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE EB.MOB.FRMWRK.FIELDS
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
    CALL Table.defineId("ACTION.ID", T24_String)  ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("ROUTINE", T24_String, Field_Mandatory, "")   ;* Add a new fields
    CALL Table.addField("FILTER.RTN", T24_String, "", "")   ;* Add a new fields
    CALL Table.addField("XX<APPL", T24_String, "", "")      ;* Has "UserId,TokenId"
    CALL Field.setCheckFile('PGM.FILE')
*    CALL Table.addField("XX-XX<APPL.FIELDS", T24_String, "", "")      ;* Add a new fields
	CALL Table.addFieldDefinition("XX-XX<APPL.FIELDS", "50", "A", "") ;* Add a new field
    CALL Table.addField("XX>XX>APPL.COL.NAMES", T24_String, "", "")
    CALL Table.addField("INPUT.FORMATTER", T24_String, "", "")
    CALL Table.addField("OUTPUT.FORMATTER", T24_String, "", "")

*    CALL Table.addField("ACTION.INFO", T24_String, "", "")  ;* Has "UserId,TokenId"
*    CALL Table.addField("ARG1", T24_String, "", "")         ;* Add a new fields
*    CALL Table.addField("ARG2", T24_String, "", "")         ;* Add a new fields
*    CALL Table.addField("ARG3", T24_String, "", "")         ;* Add a new fields
*    CALL Table.addField("ARG4", T24_String, "", "")         ;* Add a new fields
*    CALL Table.addField("ARG5", T24_String, "", "")         ;* Add a new fields
*    CALL Table.addField("RESPONSE", T24_String, "", "")     ;* Add a new fields
*    CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*    CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
