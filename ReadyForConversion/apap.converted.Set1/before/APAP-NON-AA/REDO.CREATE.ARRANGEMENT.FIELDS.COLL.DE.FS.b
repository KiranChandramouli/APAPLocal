*-----------------------------------------------------------------------------
* <Rating>-28</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CREATE.ARRANGEMENT.FIELDS.COLL.DE.FS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine GENERAL ARRANGEMENT FIELDS
* @author MGUDINO@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
* 2/6/2011   MGUDINO
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*** </region>
  neighbour = ''
  GOSUB DEFINE.COLL.DE
  GOSUB DEFINE.COLL.FS

  CALL REDO.CREATE.ARRANGEMENT.FIELDS.SEC.DIS

  RETURN


DEFINE.COLL.DE:
*
  fieldName = 'XX<SEC.NO.STATE.DE'
  fieldLength = '18'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL")
*
  fieldName = 'XX-TYPE.OF.SEC.DE'
  fieldLength = '3'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL.CODE")
*
  fieldName = 'XX-SEC.CLASSIFY.DE'
  fieldLength = '3'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL.TYPE")
*
  fieldName = 'XX-SEC.HLD.IDEN.DE'
  fieldLength = '10'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("CUSTOMER")
*
  fieldName = 'XX-COLL.CURRENCY.DE'
  fieldLength = '3'
  fieldType = 'CCY'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("CURRENCY")
*
  fieldName = 'XX-SEC.CREATE.DATE.DE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GRANTING.DATE.DE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-EXECUTING.DATE.DE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-SEC.VALUE.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-SEC.EXE.VAL.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GEN.LEDGER.VAL.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-CENT.BANK.VAL.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-LOAN.MAX.PERC.DE'
  fieldLength = '3'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-MAX.LOAN.AMT.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-AVAIL.COLL.BAL.DE'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-REMARKS.DE'
  fieldLength = '100'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-INSMNT.ISS.ENT.DE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("REDO.ISSUE.ENTITY")
*
  fieldName = 'XX-INSMN.TYPE.GTIA.DE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("REDO.INSTRUMENT.TYPE")
*
  fieldName = 'XX-NAME.COLL.OWNER.DE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-RNC.INSMNT.ISS.DE'
  fieldLength = '16'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-NUM.INSMNT.GTIA.DE'
  fieldLength = '25'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-MATUR.DATE.DE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  CALL Table.addReservedField('XX-RESERVED.5.DE')
  CALL Table.addReservedField('XX-RESERVED.4.DE')
  CALL Table.addReservedField('XX-RESERVED.3.DE')
  CALL Table.addReservedField('XX-RESERVED.2.DE')
  CALL Table.addReservedField('XX>RESERVED.1.DE')


  RETURN
*-----------------------------------------------------------------------------------------------------------------

DEFINE.COLL.FS:
*
  fieldName = 'XX<SEC.NO.STATE.FS'
  fieldLength = '18'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL")
*
  fieldName = 'XX-TYPE.OF.SEC.FS'
  fieldLength = '3'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL.CODE")
*
  fieldName = 'XX-SEC.CLASSIFY.FS'
  fieldLength = '3'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("COLLATERAL.TYPE")
*
  fieldName = 'XX-SEC.HLD.IDEN.FS'
  fieldLength = '10'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("CUSTOMER")
*
  fieldName = 'XX-COLL.CURRENCY.FS'
  fieldLength = '3'
  fieldType = 'CCY'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("CURRENCY")
*
  fieldName = 'XX-SEC.CREATE.DATE.FS'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GRANTING.DATE.FS'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-EXECUTING.DATE.FS'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-SEC.VALUE.FS'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-SEC.EXE.VAL.FS'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GEN.LEDGER.VAL.FS'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  neighbour = ''
  fieldName = 'XX-CENT.BANK.VAL.FS'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-AVAIL.COLL.BAL.FS'
  fieldLength = '19'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  neighbour = ''
  fieldName = 'XX-REMARKS.FS'
  fieldLength = '100'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-LOAN.DEBTOR.ID.FS'
  fieldLength = '10'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-LOAN.DEB.NAME.FS'
  fieldLength = '50'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-LOAN.DEB.LEG.ID.FS'
  fieldLength = '20'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GUARAN.ID.FS'
  fieldLength = '10'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GUARAN.NAME.FS'
  fieldLength = '50'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-GUARAN.LEGAL.ID.FS'
  fieldLength = '20'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  fieldName = 'XX-TYPE.JOINT.GUAR.FS'
  fieldLength = '100'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

  CALL Table.addReservedField('XX-RESERVED.5.FS')
  CALL Table.addReservedField('XX-RESERVED.4.FS')
  CALL Table.addReservedField('XX-RESERVED.3.FS')
  CALL Table.addReservedField('XX-RESERVED.2.FS')
  CALL Table.addReservedField('XX>RESERVED.1.FS')

  RETURN
*------------------------------------------------------------------------------------------------------------------

END
