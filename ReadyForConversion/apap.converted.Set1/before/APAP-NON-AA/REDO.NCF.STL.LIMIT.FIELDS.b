*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NCF.STL.LIMIT.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.NCF.STL.LIMIT.FIELDS
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
* 09-05-2015        Prabhu.N          NCF               Initial Creation
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
  ID.N="6.1"
  ID.T=""
  ID.T<2> ='SYSTEM'

*-----------------------------------------------------------------------------

  fieldName="XX<USER.TYPE"
  fieldLength="15"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-MIN.LIMIT"
  fieldLength="3"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX>MAX.LIMIT"
  fieldLength="3"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
