*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.ORDER.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.H.ORDER.DETAILS
*---------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*---------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.H.ORDER.DETAILS.FIELDS
*---------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* --------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("REDO.H.ORDER.DETAILS", T24_String)
  ID.F = '@ID'
  ID.N = '16'
  ID.T = 'A'

*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
* CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

  fieldName = 'ORDER.REFERENCE'
  fieldLength = '16'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'INPUT.USER'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'AUTH.USER'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ITEM.CODE'
  fieldLength = '15'
  fieldType = 'A'
  neighbour =''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DESCRIPTION'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REQUEST.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX<SERIES.FROM'
  fieldLength = '16'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX>SERIES.TO'
  fieldLength = '16'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REQUEST.COMPANY'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'DEST.COMPANY'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'ORDER.STATUS'
  fieldLength = '15'
*fieldType = '':FM:'Order Pending to Deliver_Order Submitted to SAP_Embossed Debit Card Order_Delivered Order_Received Order_Rejected Order_Transfered Order_Order Received by Transfer_Returned order_Received returned order'    ;*HAVE TO CHANGE THE OPTIONS
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DATE.SUBMIT.TO.SAP'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DELEVIRY.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DELEVIRY.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REJECTED.ORDER'
  fieldLength = '3'
  fieldType<1> = ''
  fieldType<2> = 'YES_NO'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REASON.REJECT'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REJECT.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'RECEIPT.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REJ.RECEIPT'
  fieldLength = '3'
  fieldType<1> = ''
  fieldType<2> = 'YES_NO'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName = 'RSN.RECIEPT.REJ'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TRANSFER.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TRANSFER.FROM'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'TRANSFER.TO'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'TRANSFER.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'RETURN.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'RETURN.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DESTROY.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DESTROY.REASON'
  fieldLength = '35'
  fieldType ='A'
  neighbour =''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DESTROY.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CANCEL.QUANTITY'
  fieldLength = '5'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CANCEL.REASON'
  fieldLength = '65'
*    fieldType = '':FM:'Physical series taken by error_Non-located series (physically lost)_Form with printing error_Series incorrectly registered in the inventory_Printed series with errors_Blocked debit card  internally lost_Blocked debit card due to embossing error'
  fieldType = 'A'
  virtualTableName = 'L.CANCEL.REASON'
  neighbour = ''
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


  fieldName = 'DEPARTMENT'
  fieldLength = '30'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('REDO.H.DEP.DETAILS')

  fieldName = 'BRANCH.CODE'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('REDO.ISSUE.DEPT.CODE')

  fieldName = 'BRANCH.DES'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BRANCH.TRAN.CODE'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BRANCH.TRAN.DES'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName = 'SERIES.ID'
  fieldLength = '10'
  fieldType = 'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")

  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<3> = 'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
