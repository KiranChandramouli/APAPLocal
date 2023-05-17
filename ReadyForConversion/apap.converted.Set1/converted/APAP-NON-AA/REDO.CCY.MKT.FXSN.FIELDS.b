SUBROUTINE REDO.CCY.MKT.FXSN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCY.MKT.FXSN *
* @author tchandru@temenos.com
* @stereotype fields template
* Reference :
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
* Date           Author             Reference         Description
* 16-Sep-2010    Chandra Prakash T  ODR-2010-09-0014  Change Request CR 023 - CURRENCY MARKET & Exchange Rates
* 29/05/2013     Vignesh Kumaar R   PACS00293402      TOO MANY CHARACTERS
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T<1> = ''
    ID.T<2> = 'SYSTEM'
*------------------------------------------------------------------------------
    fieldName = 'DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX<CCY.MKT.CODE'
    fieldLength = '35.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX-CCY.MKT'
    fieldLength = '2'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('CURRENCY.MARKET')

    fieldName = 'XX-TT.VERSION'
*    fieldLength = '35'
    fieldLength = '54'          ;* Fix for PACS00293402 [TOO MANY CHARACTERS]
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('VERSION')

    fieldName = 'XX>TT.TRANS.CODE'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('TELLER.TRANSACTION')

    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX.STMT.NOS'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
