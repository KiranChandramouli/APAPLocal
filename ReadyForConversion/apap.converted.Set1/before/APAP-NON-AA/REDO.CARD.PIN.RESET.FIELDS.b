*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.PIN.RESET.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.CARD.PIN.RESET
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
* 12-05-2011           Prabhu.N      PACS00054646         Initial Creation
*----------------------------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '16'
  ID.T = ''
*-----------------------------------------------------------------------------

  fieldName="CUSTOMER.ID"
  fieldLength="10"
  fieldType=''
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="XX.NAME.ON.PLASTIC"
  fieldLength="35"
  fieldType="A"
  fieldType<3>='NOINPUT'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ACCOUNT.NO"
  fieldLength="10"
  fieldType="A"
  fieldType<3>='NOINPUT'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="DATE.OF.BIRTH"
  fieldLength="8"
  fieldType="D"
  fieldType<2>='1000'
  fieldType<3>='NOINPUT'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="LAST.REST.DATE"
  fieldLength="8"
  fieldType="D"
  fieldType<3>='NOINPUT'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESET.DATE"
  fieldLength="8"
  fieldType="D"
  fieldType<3>='NOINPUT'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   ="TIME.RESET"
  fieldLength ="20"
  fieldType   =""
  fieldType<3>='NOINPUT'
  neighbour   =""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
