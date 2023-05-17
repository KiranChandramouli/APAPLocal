SUBROUTINE APAP.H.INSURANCE.EVENTFIELD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine APAP.H.INSURANCE.EVENTFIELD.FIELDS
*
* @author jvalarezoulloa@temenos.com, pgarzon@temenos.com,sjijon@temenos.com
*         cherrera@temenos.com
* @stereotype fields template
* @public Table Creation
* @uses Table
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 16/06/11 - New Template changes
*
*-----------------------------------------------------------------------------
*** <region name= RTAM>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("FIELD.ID", T24_String)     ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addField("FIELD.DESC", T24_String,'', '')      ;* Add a Description Field
    CALL Table.addField("XX<FIELD.VALUE", T24_String,'', '')
    CALL Table.addField("XX-XX<ASSOCIATED.FIELDS",T24_String,'','')
    fieldName="XX>XX>ASSOCIATED.ACTION"
    ebLoookUpTable = "REDO.INS.ASSOCIATED.FIELD.ACTION"
    CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');

*------------------------------------------------------------------------------

    CALL Table.addReservedField('RESERVED.20')
    CALL Table.addReservedField('RESERVED.19')
    CALL Table.addReservedField('RESERVED.18')
    CALL Table.addReservedField('RESERVED.17')
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
*-----------------------------------------------------------------------------
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
