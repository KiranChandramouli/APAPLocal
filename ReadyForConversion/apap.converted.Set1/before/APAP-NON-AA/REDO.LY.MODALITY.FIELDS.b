*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.MODALITY.FIELDS
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

*  DATE             WHO         REFERENCE         DESCRIPTION
* 05-04-2010      GANESH      ODR-2009-12-0276   INITIAL CREATION
* 22-07-2011    RMONDRAGON    ODR-2011-06-0243   UPDATE TO ENTIRE APPLICATION
* 24-05-2012    RMONDRAGON    ODR-2011-06-0243   UPDATE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("REDO.LY.MODALITY", T24_String)       ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID' ; ID.N = '9'
  ID.T = 'A'

  fieldName='NAME'
  fieldLength='50'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TYPE'
  fieldLength='1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('REDO.LY.MODTYPE')

  fieldName='XX<CHANNEL'
  fieldLength='6'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.CHANNEL")

  fieldName='XX-APP.TXN'
  fieldLength='3'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.APPLICATION")

  fieldName='XX>XX.TXN.CODE'
  fieldLength='5'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("TRANSACTION")

  fieldName='CURRENCY'
  fieldLength='5'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("CURRENCY")

  fieldName='FORM.GENERATION'
  fieldLength='1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.GENFORM")

  fieldName='PRODUCT.GROUP'
  fieldLength='3'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.PDT.TYPE")

  fieldName='MIN.DISBURSE.AMT'
  fieldLength='18'
  fieldType='AMT'
  fieldType<2,2>='6'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX<GEN.POINTS'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX-LOW.LIM.AMT'
  fieldLength='7'
  fieldType='AMT'
  fieldType<2,2>='6'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX>UP.LIM.AMT'
  fieldLength='7'
  fieldType='AMT'
  fieldType<2,2>='6'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX<INT.GEN.POINTS'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX-INT.LOW.LIM.AMT'
  fieldLength='7'
  fieldType='AMT'
  fieldType<2,2>='6'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX>INT.UP.LIM.AMT'
  fieldLength='7'
  fieldType='AMT'
  fieldType<2,2>='6'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='GEN.FACTOR'
  fieldLength='7'
  fieldType='AMT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='MIN.GEN'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='MAX.GEN'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='INT.GEN.FACTOR'
  fieldLength='7'
  fieldType='AMT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='INT.MIN.GEN'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='INT.MAX.GEN'
  fieldLength='7'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='EVENT'
  fieldLength='2'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.LY.EVENT")

  fieldName='XX.EX.PROD.AS'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='GEN.AMT'
  fieldLength='7'
  fieldType=''
  fieldType<2>='Total_Capital_Interes'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='ANTIG'
  fieldLength='3'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
