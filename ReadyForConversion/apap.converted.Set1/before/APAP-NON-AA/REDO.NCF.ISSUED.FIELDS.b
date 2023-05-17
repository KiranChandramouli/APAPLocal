*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NCF.ISSUED.FIELDS
*DESCRIPTION:
*------------
*This routine defines fields for the table REDO.NCF.ISSUED

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*----------------------------------------------------------------------------------------------------------------------
* Revision History:
*----------------------------------------------------------------------------------------------------------------------
*   Date        who                   Reference           Description
* 23-FEB-2010   Ganesh.R              ODR-2009-10-0321    Initial Creation.
* 15-JUL-2013   VIGNESH KUMAAR M R    PACS00294931        FOR OTHER BANK CUSTOMER ID.NUMBER TO BE DISPLAYED IN CUSTOMER FIELD
* 08-MAY-2015   Senthil               Go-Live-Hot-Fix     Changed Multi Value Fld into Single, to Index the fld TXN.ID
*----------------------------------------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="65"
  ID.T="A"
*-----------------------------------------------------------------------------
*    fieldName="XX<TXN.ID"      ;* Commented on 8May2015
  fieldName="TXN.ID"
  fieldLength="16"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="XX-TXN.CHARGE"  ;* Commented on 8May2015
  fieldName="TXN.CHARGE"
  fieldLength="16"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="XX>TXN.TAX"     ;* Commented on 8May2015
  fieldName="TXN.TAX"
  fieldLength="16"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="TXN.TYPE"
  fieldLength="8"
  fieldType<2>="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX.NCF"
  fieldLength="19"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="MODIFIED.NCF"
  fieldLength="19"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CHARGE.AMOUNT"
  fieldLength="20"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TAX.AMOUNT"
  fieldLength="20"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="DATE"
  fieldLength="8"
  fieldType="D"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ACCOUNT"
  fieldLength="15"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CUSTOMER"
  fieldLength="15"  ;* changed for PACS00294931
  fieldType="CUS"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* Commented for PACS00294931 [FOR OTHER BANK CUSTOMER ID.NUMBER TO BE DISPLAYED IN CUSTOMER FIELD]
*    CALL Field.setCheckFile("CUSTOMER")
* End of Fix

  fieldName="BATCH"
  fieldLength="3"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ID.TYPE"
  fieldLength="15"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ID.NUMBER"
  fieldLength="15"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
END
