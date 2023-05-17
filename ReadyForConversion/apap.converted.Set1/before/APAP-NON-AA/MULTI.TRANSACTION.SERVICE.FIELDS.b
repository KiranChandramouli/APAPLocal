*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE MULTI.TRANSACTION.SERVICE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '25'
  ID.T = 'A'

  fieldName="TELLER.ID"
  fieldLength="4"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="OPERATION"
  fieldLength="30"
  fieldType<2>="DISBURSEMENT_REPAYMENT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TRANSACTION.DATE"
  fieldLength="20"
  fieldType="D"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TOTAL.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldType = ""
  fieldName="SETTLEMENT.TYPE"
  fieldLength="8"
  fieldType<1>=""
  fieldType<2>="SINGLE_MULTIPLE"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ARRANGEMENT.ID"
  fieldLength="25"
  fieldType="ARR"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="NO.OF.CHEQUES"
  fieldLength="3"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESIDUAL"
  fieldLength="3"
  fieldType<2>="YES_NO"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESIDUAL.MODE"
  fieldLength="20"
  fieldType<2>="CASH_CHEQUE_ACCOUNT.TRANSFER"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="SETTLEMENT.MODE"
  fieldLength="20"
  fieldType<2>="CASH_CHEQUE_ACCOUNT.TRANSFER"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CASH.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CHEQUE.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="NET.AMOUNT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="TRANSFER.AMOUNT"
*    fieldLength="19"
*    fieldType="AMT"
*    neighbour=""
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX<PAYMENT.MODE"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('MULTI.TRANSACTION.PARAMETER')

  fieldName="XX-PAYMENT.TYPE"
  fieldLength="28"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*   CALL Field.setCheckFile('MULTI.TRANSACTION.PARAMETER':FM:'REDO.TXN.PARAM.SHORT.DESC')

  fieldName="XX-ARR.ID"
  fieldLength="12"
  fieldType="ARR"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-CURRENCY"
  fieldLength="3"
  fieldType="CCY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fileName='CURRENCY'
  CALL Field.setCheckFile(fileName)

  fieldName="XX-OD.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-OD.BILLS"
  fieldLength="3"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-TRANSACTION.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-ACCOUNT.SETTLEMENT"
  fieldLength="10"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-STATUS"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-CHEQUE.NO"
  fieldLength="30"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-TRANSACTION.ID"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-VERSION.NAME"
  fieldLength="60"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*fieldName="XX-VERSION.DESC"
*fieldLength="60"
*fieldType="A"
*neighbour=""
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*fieldName="XX-TT.TXN"
*fieldLength="35"
*fieldType="A"
*neighbour=""
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.10"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.9"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.8"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.7"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.6"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.5"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.4"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.3"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-RESERVED.2"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX>RESERVED.1"
  fieldLength="20"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="AMT.TO.BE.PAID"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="REMAINDER.AMT"
  fieldLength="19"
  fieldType="AMT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="VERSION.1"
  fieldLength="15"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="VERSION.2"
  fieldLength="15"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="VERSION.3"
  fieldLength="15"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TRANSFER.AMT"
  fieldLength="15"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  CALL Table.addReservedField('RESERVED.20')
  CALL Table.addReservedField('RESERVED.19')
  CALL Table.addReservedField('RESERVED.18')
  CALL Table.addReservedField('RESERVED.17')
  CALL Table.addReservedField('RESERVED.16')
  CALL Table.addReservedField('RESERVED.15')
  CALL Table.addReservedField('RESERVED.14')
  CALL Table.addReservedField('RESERVED.13')
  CALL Table.addReservedField('RESERVED.12')
*    CALL Table.addReservedField('RESERVED.11')

*    fieldName = 'RESERVED.11' ;  fieldType = T24_String ; GOSUB ADD.RESERVED.FIELDS

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')
  CALL Table.addOverrideField
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
