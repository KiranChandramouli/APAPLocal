*-----------------------------------------------------------------------------
* <Rating>-135</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.THIRDPRTY.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* date            name           ref                             who
* 14 jul 2011    Prabhu         PACS00071462                   Line100-instead of cash effectivo is added
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
  ID.N="3"
  ID.T="A"
  ID.T<3>="NOINPUT"
*-----------------------------------------------------------------------------
  fieldName="COMP.NAME"
  fieldLength="20.1"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName ="BILL.TYPE"
  fieldLength ="20.1"
  fieldType="A"
  neighbour=""
  table = 'BILL.TYPE'
  CALL Table.addFieldWithEbLookup(fieldName, table, neighbour)

  fieldName ="XX.BILL.COND"
  fieldLength ="45.1"
  fieldType="A"
  neighbour=""
  table = 'BILL.COND'
  CALL Table.addFieldWithEbLookup(fieldName, table, neighbour)

  fieldName ="STATUS"
  fieldLength ="1"
  fieldType="":FM:"A_D"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="INTERFACE.REQ"
  fieldLength ="1"
  fieldType="":FM:"Y_N"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName ="XX<METHOD.DESC"
  fieldLength ="35"
  fieldType="":FM:"getBalanceByNumber_ProcessPayment_PaymentReverse"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="XX>METHOD.NAME"
  fieldLength ="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="INTERFACE.USER"
  fieldLength ="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="INTERFACE.PASS"
  fieldLength ="20"
  fieldType="PASSWD"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* C.19 Additional Fields

  fieldName ="PHONE.STATUS"
  fieldLength ="1"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="XX<PAY.MODE"
  fieldLength ="13"
*    fieldType="":FM:"CASH_CHEQUE"
*    fieldType="":FM:"EFECTIVO_CHEQUE"
  neighbour=""
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  table = 'PAY.MODE'
  CALL Table.addFieldWithEbLookup(fieldName, table, neighbour)

  fieldName ="XX>PAY.CODE"
  fieldLength ="5"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="CHANNEL.CODE"
  fieldLength ="6"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="SHOW.ON.CHANNELS"
  fieldLength ="1"
  fieldType="":FM:"Y_N"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'RESERVED.9'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.8'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.7'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.6'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.5'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.4'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.3'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.2'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.1'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*
*-----------------------------------------------------------------------------

  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN

*-----------------------------------------------------------------------------
END
