*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.PIGGY.BANK.ASSIGNMENT.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.H.PIGGY.BANK.ASSIGNMENT
*---------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*---------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.H.PIGGY.BANK.ASSIGNMENT.FIELDS
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
  CALL Table.defineId("REDO.H.ORDER.DETAILS", T24_String)   ;* Define Table id
  ID.F = '@ID'
  ID.N = '36'
  ID.T = ''
  ID.CHECKFILE="REDO.H.SUCURSAL"

*-----------------------------------------------------------------------------
  fieldName = 'DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'QUANTITY'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'AMOUNT'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ASSIGN.CONCEPT'
  fieldLength = '30'
  fieldType = ''
  fieldType<2>="SALE_ACCOUNT OPENING_PROMOTION_FULL PIGGY BANK REPLACEMENT"
  neighbour =''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'PAY.METHOD'
  fieldLength = '35'
  fieldType = ''
  fieldType<2>="WAIVED_CASH_ACCOUNT DEBIT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DEBIT.ACCOUNT'
  fieldLength = '15'
  fieldType= ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<1> = 'A'
  fieldType<3> = 'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
