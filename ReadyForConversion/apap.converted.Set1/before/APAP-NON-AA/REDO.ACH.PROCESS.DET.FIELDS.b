*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACH.PROCESS.DET.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ACH.PROCESS.DET.FIELDS
* @author rswaminathan@contractor.temenos.com
* @stereotype fields template
* Reference : ODR2009120290
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.REDO.ACH.PROCESS
$INSERT I_F.REDO.ACH.REJECT.CODE

*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'TXN.CODE'
  fieldLength = '2'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TXN.AMOUNT'
  fieldLength = '18'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ACCOUNT'
  fieldLength = '17'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile("ACCOUNT")

  fieldName = 'PARTICIP.NAME'
  fieldLength = '22'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TXN.ID'
  fieldLength = '18'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'PARTICIP.ID'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TXN.DESCRIPTION'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ADDIT.INFO'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ORIGINATOR.NAME'
  fieldLength = '22'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ORIGINATOR.ID'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ORIGINATOR.ACCT'
  fieldLength = '16'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ORIGINATOR.B.ID'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'EXEC.ID'
  fieldLength = '20'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('REDO.ACH.PROCESS')

  table = 'ACH.STATUS'
  fieldName = 'STATUS'
  fieldLength = '2'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName, table, neighbour)

  fieldName = 'REJECT.CODE'
  fieldLength = '3'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('REDO.ACH.REJECT.CODE')

  fieldName = 'T24.TXN.ID'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ERROR.MSG'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

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
