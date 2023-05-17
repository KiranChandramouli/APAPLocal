*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TELLER.REJECT.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.TELLER.PROCESS
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
* 23-04-2010        Prabhu.N          N.78               Initial Creation
* 26-05-2011         Sudharsanan S     PACS00062653      Modify the fields as per new workaround solution provided
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

  fieldName="CLIENT.ID"
  fieldLength="10"
  fieldType="CUS"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CUSTOMER')

  fieldName="CLIENT.NAME"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="PAYMENT.TYPE"
  fieldLength="20.1"
  fieldType="":FM:"CASH_CHEQUE_TRANSFER"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="GROUP"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  virtualTableName='L.TT.GROUP'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName="SUB.GROUP"
  fieldLength="65"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CONCEPT"
  fieldLength="65"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CURRENCY"
  fieldLength="3"
  fieldType="CCY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CURRENCY')

  fieldName="AMOUNT"
  fieldLength="25"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="STATUS"
  fieldLength="15"
  fieldType="A":FM:"":FM:"NOINPUT"
  neighbour=""
  virtualTableName='L.TT.STATUS'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName="CATEGORY"
  fieldLength="6"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

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

  fieldName ="XX.STMT.NO"
  fieldLength ="35"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="XX.OVERRIDE"
  fieldLength ="35"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
