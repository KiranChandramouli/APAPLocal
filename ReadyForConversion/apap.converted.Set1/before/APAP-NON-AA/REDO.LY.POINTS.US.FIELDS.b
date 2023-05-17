*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.POINTS.US.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.POINTS.US.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 01-06-2012    RMONDRAGON   ODR-2011-06-0243   INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("REDO.LY.POINTS.US", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID' ; ID.N = '20'
  ID.T = 'A'

  fieldName='CUSTOMER.NO'
  fieldLength='10'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("CUSTOMER")

  fieldName='DATE'
  fieldLength='11'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='PROGRAM'
  fieldLength='8'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.PROGRAM")

  fieldName='TYPE.US'
  fieldLength='12'
  fieldType=''
  fieldType<2>='Normal_Por.TDebito'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TXN.REF.US'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='QTYORVAL'
  fieldLength='7'
  fieldType=''
  fieldType<2>='Puntos_Monto'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='QTYORVAL.TO.US'
  fieldLength='12'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='QUANTITY'
  fieldLength='10'
  fieldType='ANY'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='QTY.VALUE'
  fieldLength='12'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='DESC.US'
  fieldLength='55'
  fieldType='ANY'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='MOV.US'
  fieldLength='22'
  fieldType=''
  fieldType<2>='Interno_Cuenta.Ahorro.Cliente'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='CUS.ACCT.MOV.US'
  fieldLength='19'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile("ACCOUNT")

  fieldName='INT.ACCT.MOV.US'
  fieldLength='19'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile("ACCOUNT")

  fieldName='TXN.REF.MOV.US'
  fieldLength='25'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("FUNDS.TRANSFER")

  fieldName='STATUS.US'
  fieldLength='2'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.POINTUSSTA")
  
    
  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
