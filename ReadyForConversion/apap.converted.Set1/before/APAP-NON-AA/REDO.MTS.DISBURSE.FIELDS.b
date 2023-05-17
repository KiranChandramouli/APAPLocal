*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MTS.DISBURSE.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.MTS.DISBURSE
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-11-2010          JEEVA T        ODR-2010-08-0017     Initial Creation
* 17-08-2011          Bharath G      PACS00085750         Field added to capture Credit Value Date
* 09-09-2011          Marimuthu S    PACS00121111
* 19-01-2012          Walid K        PACS00175273         Field added to capture Document number
*------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="35"
  ID.T="A"
*-----------------------------------------------------------------------------
  fieldName="ARRANGEMENT.ID"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('AA.ARRANGEMENT')

  fieldName="CURRENCY"
  fieldLength="3"
  fieldType="CCY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CURRENCY')

  fieldName="CUSTOMER.NO"
  fieldLength="25"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CUSTOMER')

  fieldName="LN.ACCOUNT.NO"
  fieldLength="25"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TRAN.TYPE"
  fieldLength="25"
  fieldType='':FM:"CASH_CHEQUE_DEPOSIT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="AMOUNT"
  fieldLength="25"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="BR.AC.NUMBER"
  fieldLength="25"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="BRANCH.ID"
  fieldLength="20"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile('%REDO.BRANCH.COMPANY')

  fieldName="CHEQUE.TYPE"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX.BENEFICIARY"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="NARRATIVE"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="REMARKS"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="AZ.ACCOUNT"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="AZ.ACCT.STATUS"
  fieldLength="30"
  fieldType='':FM:"AUTHORISED_REVERSED_PROCESSED"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="REF.ID"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="VALUE.DATE"
  fieldLength="10"
  fieldType="D"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="BEN.ACCT.NO"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ROUTING.NO"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
* CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
* CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
* CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
* CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
* CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

  fieldName ="XX.PAYMENT.DETAILS"
  fieldLength ="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

** PACS00121111 - S
  fieldName ="ADMIN.CQ.TYPE"
  fieldLength ="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
** PACS00121111 - E

** PACS00175273 - S
  fieldName ="IDENTITY.DOC"
  fieldLength ="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
** PACS00175273 - E

*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
