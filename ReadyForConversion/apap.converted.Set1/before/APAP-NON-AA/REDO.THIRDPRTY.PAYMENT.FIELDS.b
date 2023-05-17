*-----------------------------------------------------------------------------
* <Rating>-6</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.THIRDPRTY.PAYMENT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.THIRDPRTY.PAYMENT.FIELDS
*
* @author GANESHR@temenos.com
* @LIVE template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  Date          who                  Reference       Description
*  11 JAN 2010   GANESH                               INITIAL CREATION
*  12 JUL 2013   VIGNESH KUMAAR M R   PACS00307024    SELECTION TO BE BASED ON THE COMPANY
*  30 JUL 2013   VIGNESH KUMAAR M R   PACS00307023    THIRDPARTY PAYMENT ENQ DROPDOWN
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id

  ID.F="@ID"
  ID.N="12"
  ID.T ="A"

  fieldName="BRANCH"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
  CALL Field.setCheckFile('REDO.THIRDPRTY.PARAMETER')       ;* Fix for PACS00307023 [THIRDPARTY PAYMENT ENQ DROPDOWN]

  fieldName="TELLER.ID"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="TELLER.NAME"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="COMP.NAME"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="BILL.COND"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="BILL.TYPE"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="BILL.NUMBER"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="METHOD.OF.PAY"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="AMOUNT"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="CHEQUE.NUMBER"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

* Fix for PACS00307024 [SELECTION TO BE BASED ON THE COMPANY]

  fieldName = "PAY.COMPANY"
  fieldLength = "9"
  fieldType = "A"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
  CALL Field.setCheckFile('COMPANY')    ;* Fix for PACS00307023 [THIRDPARTY PAYMENT ENQ DROPDOWN]

* End of Fix

  RETURN

*-----------------------------------------------------------------------------
END
