SUBROUTINE REDO.W.DIRECT.DEBIT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author pgarzongavilanes@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/03/11 - First release
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '25'
    ID.T = "A"   ;
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX.ARR.ID", "35", "A", "") ;* Add a new fields
    CALL Table.addFieldDefinition("XX.FT.ID", "55", "A", "")

    CALL Table.addFieldDefinition("XX<CREDIT.AC.ID", "35", "A", "")

    CALL Table.addFieldDefinition("XX-DEBIT.AC.ID", "35", "A", "")

    CALL Table.addFieldDefinition("XX-XX<BILL.AMT.ARR.ID", "35", "A", "")
    CALL Table.addFieldDefinition("XX-XX>BILL.ID", "100", "A", "")
    CALL Table.addFieldDefinition("XX>XX.REASON", "100", "A", "")
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
