*-----------------------------------------------------------------------------
* <Rating>-231</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.ACS.DEF.FIELDS
*-----------------------------------------------------------------------------
!** FIELD definitions FOR TEMPLATE
* @author adinesh@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*!
*-----------------------------------------------------------------------------
* Revision Histroy :
*   -Date-           -Who-          -Reference-       -Description-
* 10/05/2008       A.DINESH                          Initial Version
* 22/09/2010      SWAMINATHAN      ODR-2009-12-0264  Changed to R09 standards
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.LATAM.CARD.INTERFACE
*-----------------------------------------------------------------------------

  ID.F = "@ID" ;   ID.N = "33" ;    ID.T = "A"    ;*Card acs ID
*Interface ID
  neighbour = ''
  fieldName = 'XX<INTERFACE'
  fieldLength = '10'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('LATAM.CARD.INTERFACE')
*Balance Inquiry on ATM
  neighbour = ''
  fieldName = 'XX-BI.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Mini Statement on ATM
  neighbour = ''
  fieldName = 'XX-MS.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Withdrawal on ATM
  neighbour = ''
  fieldName = 'XX-WD.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Deposits on ATM
  neighbour = ''
  fieldName = 'XX-DP.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Transfer To Account using ATM
  neighbour = ''
  fieldName = 'XX-TI.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Transfer From Account using ATM
  neighbour = ''
  fieldName = 'XX-TO.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Bill Payment on ATM
  neighbour = ''
  fieldName = 'XX-BP.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Passbook Update on ATM
  neighbour = ''
  fieldName = 'XX-PU.FLAG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Access to POS or Extern ATM's
  neighbour = ''
  fieldName = 'XX>EN.FLAG'
  fieldLength = '9'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName='RESERVED.20'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.19'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.18'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.17'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.16'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.15'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.14'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.13'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.12'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.11'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.10'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.9'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.8'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.7'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.6'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.5'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.4'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.3'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.2'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.1'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
