SUBROUTINE REDO.CHARGE.PARAM.FIELDS
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
*----------------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*
* 28/03/2011   Krishna Murthy T.S    ODR-2011-03-0142       Added additional fields
*
*-----------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.CHARGE.PARAM", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '10'
    ID.T<1>=""   ; ID.T<2>="SYSTEM"

    CALL Table.addFieldDefinition("XX<ACCT.CATEG.STR", "4.1", "", "")   ;* Add a new field
    CALL Field.setCheckFile("CATEGORY") ;

    CALL Table.addFieldDefinition("XX>ACCT.CATEG.END", "4.1", "", "") ;
    CALL Field.setCheckFile("CATEGORY") ;

    CALL Table.addFieldDefinition("XX.CHG.TXN.CODES", "3.1", "", "") ;
    CALL Field.setCheckFile("TRANSACTION") ;

    CALL Table.addFieldDefinition("PL.CATEGORY", "5", "", "") ;
    CALL Field.setCheckFile("CATEGORY") ;

    CALL Table.addFieldDefinition("XX.PEND.ACCT.STATUS", "25", "A", "") ;

    CALL Table.addFieldDefinition("DR.TXN.CODE", "3", "", "") ;
    CALL Field.setCheckFile("TRANSACTION") ;

    CALL Table.addFieldDefinition("CR.TXN.CODE", "3", "", "") ;
    CALL Field.setCheckFile("TRANSACTION") ;

*ODR2011030142 - START

    CALL Table.addFieldDefinition("XX<FT.COMM.TYPE", "20", "A", "") ;
    CALL Field.setCheckFile("FT.COMMISSION.TYPE") ;
    VAR.VIRTUAL.TABLE = 'L.AC.STATUS1'
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    VAR.VIRTUAL.TABLE = FIELD(VAR.VIRTUAL.TABLE,@FM,2)
    fieldType = ''
    fieldType<1> = ''
    fieldType<2> = VAR.VIRTUAL.TABLE
    CALL Table.addFieldDefinition("XX-AC.STATUS.1", "18", fieldType, "") ;

    fieldType = ''
    fieldType<1> = ''
    fieldType<2> = 'DECEASED_GARNISHMENT_GUARANTEE STATUS'
    CALL Table.addFieldDefinition("XX-AC.STATUS.2", "18", fieldType, "") ;

    CALL Table.addFieldDefinition("XX-XX.CATEGORY", "6", "CAT", "") ;
    CALL Field.setCheckFile("CATEGORY") ;

    CALL Table.addFieldDefinition("XX-XX.ACCOUNT", "19", "POSANT", "") ;
    CALL Field.setCheckFile("ACCOUNT") ;

    neighbour = ''
    fieldName = 'XX>AMOUNT'
    fieldLength = '18'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*ODR2011030142 - END
*-----------------------------------------------------------------------------

    CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
