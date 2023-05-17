SUBROUTINE REDO.TRANSACTION.CHAIN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.TRANSACTION.CHAIN.FIELDS
*
* @author jvalarezoulloa@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------
* 29/03/2011 - Creation Date
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addField("TELLER.ID", T24_String,"","")        ;* Add a new fields
    CALL Field.setCheckFile("TELLER.ID")  ;* Use DEFAULT.ENRICH from SS or just field 1


    CALL Table.addField("BRANCH.CODE", T24_String, "", "")    ;* Add a new fields
    CALL Field.setCheckFile("COMPANY")    ;* Use DEFAULT.ENRICH from SS or just field 1


    CALL Table.addFieldDefinition("TRANS.DATE", 12, T24_Date, "")       ;* Add a new field
    CALL Table.addFieldDefinition("XX<TRANS.ID", 16, T24_String, "")    ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.DESC", 35, T24_String, "")  ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.VERS", 65, T24_String, "")  ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.TYPE", 5, T24_String, "")   ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.CCY", 3, T24_String, "")    ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.AMOUNT", 16, T24_Numeric, "")         ;* Add a new field
    CALL Table.addFieldDefinition("XX>TRANS.STATUS", 4, T24_String, "") ;* Add a new field
    CALL Table.addFieldDefinition("CASH.BALANCE", 16, T24_Numeric, "")  ;* Add a new field
    CALL Table.addFieldDefinition("CHECK.BALANCE", 16, T24_Numeric, "") ;* Add a new field
    CALL Table.addFieldDefinition("TOTAL.CASH", 16, T24_Numeric, "")    ;* Add a new field
    CALL Table.addFieldDefinition("TOTAL.CHECK", 16, T24_Numeric, "")   ;* Add a new field
    CALL Table.addFieldDefinition("TRANS.AUTH", 8, T24_String, "")      ;* Add a new field

    CALL Table.addFieldDefinition("XX<CCY.INFO", 4, T24_String, "")     ;* Add a new field
    CALL Table.addFieldDefinition("XX-CASH.INFO", 16, T24_Numeric, "")  ;* Add a new field
    CALL Table.addFieldDefinition("XX>CHECK.INFO",16, T24_Numeric, "")  ;* Add a new field
    CALL Table.addFieldDefinition("XX<CHEQUE.NO",35,T24_String,"")      ;* Add a new field
    CALL Table.addFieldDefinition("XX-CHEQUE.AMT",35,T24_String,"")     ;* Add a new field
    CALL Table.addFieldDefinition("XX>CHEQUE.STATUS",35,T24_String,"")  ;* Add a new field
    CALL Table.addFieldDefinition("XX.CHQ.PROC.STAT",35,T24_String,"")  ;* Add a new field

    V = Table.currentFieldPosition
*-----------------------------------------------------------------------------


RETURN
*-----------------------------------------------------------------------------
END
