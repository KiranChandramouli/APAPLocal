SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.TECHNICAL.RESERVES.FIELDS
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 14/March/2010 - EN_10003543
*                 New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CURRENCY
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
    dataType      = ''
    dataType<2>   = 16.1
    dataType<3>   = ''
    dataType<3,2> = 'SYSTEM'
    CALL Table.defineId("@ID", dataType)  ;* Define Table id
*-----------------------------------------------------------------------------
    nArrayItem = "4"
    tArrayItem = "CCY"
    CALL Table.addFieldDefinition("LOCAL.CCY", nArrayItem, tArrayItem,neighbour)
    CHECKFILE(Table.currentFieldPosition) ="CURRENCY":@FM:EB.CUR.CCY.NAME:@FM:"L"
    T(Table.currentFieldPosition)<3> = "NOINPUT"
*
    nArrayItem = "19.1"
    tArrayItem = "LAMT" : @FM : "" : @VM : LCCY
    CALL Table.addFieldDefinition("TECH.RES.AMOUNT", nArrayItem, tArrayItem,neighbour)
*
    CALL Table.addField("EFFECTIVE.DATE", T24_Date, Field_Mandatory, '')          ;* Add a new fields
*
    CALL Table.addReservedField("RESERVED.1")       ;* Add a new Reserved fields
    CALL Table.addReservedField("RESERVED.2")       ;* Add a new Reserved fields
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
