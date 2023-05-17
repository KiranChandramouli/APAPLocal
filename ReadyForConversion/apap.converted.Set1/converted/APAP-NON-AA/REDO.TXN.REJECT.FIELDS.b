SUBROUTINE REDO.TXN.REJECT.FIELDS
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
*  DATE                WHO           REFERENCE          DESCRIPTION
* 22-11-2010      Akthar Rasool S  ODR-2010-08-0469  INITIAL CREATION
* 01 Sep 2011     Balagurunathan   ODR-2010-08-0469  Added fields
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '25'
    ID.T = 'A'



    fieldName='CARD.NUMBER'
    fieldLength='19'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACCOUNT.NUMBER'
    fieldLength='21'
    fieldType='POSANT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName='ACCOUNT.NUMBER.OLD'
    fieldLength='21'
    fieldType='POSANT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName='AVAILABLE.BALANCE'
    fieldLength='20'
    fieldType='AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MESSAGE.TYPE'
    fieldLength='4'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PROCESS.CODE'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANSACTION.AMT'
    fieldLength='12'
    fieldType='AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='BILLING.AMT'
    fieldLength='12'
    fieldType='AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRACE'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESPONSE.CODE'
    fieldLength='2'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='IST.DESC'
    fieldLength='2'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='T24.ERR.MSG'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='AUTH.CODE'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REFERENCE.NUMBER'
    fieldLength='12'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='LOCAL.DATE'
    fieldLength='4'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='LOCAL.TIME'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CAPTURE.DATE'
    fieldLength='8'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TERM.ID'
    fieldLength='8'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCHANT.ID'
    fieldLength='8'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACCEPTOR.NAME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CURRENCY.CODE'
    fieldLength='3'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CONVERSION.RATE'
    fieldLength='8'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ISSUER'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANS.DATETIME'
    fieldLength='10'
    fieldType='DATE.TIME'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CARD.EXPIRY'
    fieldLength='4'
    fieldType = 'A'

    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACQ.COUNTRY.CDE'
    fieldLength='3'
    fieldType = 'A'


    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACQ.INST.CDE'
    fieldLength='10'
    fieldType = 'A'

    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='FWD.INST.CDE'
    fieldLength=''
    fieldType = 'A'

    neighbour=''

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ADD.AMT'
    fieldLength='120'
    fieldType = 'TEXT'

    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MRCHT.CATEG'
    fieldLength='4'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POS.ENTRY.MOD'
    fieldLength='2'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POS.COND'
    fieldLength='13'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='T24.DATE'
    fieldLength='8'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MTI.RESP'
    fieldLength='4'
    fieldType = 'ANY'

    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
