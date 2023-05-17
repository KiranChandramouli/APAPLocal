SUBROUTINE LATAM.CARD.LIM.DEF.ADD.FIELDS
*-------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @parun@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*-------------------------------------------------------------------------
* * Revision History:
*------------------
* Date               who           Reference            Description
* 05/09/2008       ARUN.P                              Initial Version
* 22-SEP-2010  SWAMINATHAN.S.R   ODR-2010-03-0400      CHANGED AS PER R9 STANDARDS
*-------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    ID.F = "@ID" ; ID.N = "20" ; ID.T = "A"         ;*Customer Group ID
    ID.CHECKFILE = "CUSTOMER"

    neighbour = ''
    fieldName = 'XX.PRIM.CARD.NUM'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX<AVG.BAL.FROM'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-AVG.BAL.TO'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-MTHLY.AC.AVG.BAL'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-LIMIT.VALID.UNTIL'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY ATM WITHDRAWAL LIMIT
    neighbour = ''
    fieldName = 'XX-DA.ATMWDL.LIM'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MAXIMUM AMOUNT PER ATM TRANSACTION
    neighbour = ''
    fieldName = 'XX-MX.ATM.TRAN.LIM'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY QUANTITY OF ATM TRANSACTION
    neighbour = ''
    fieldName = 'XX-DA.ATM.TRAN.QTY'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MONTHLY QUANTITY OF ATM TRANSACTION
    neighbour = ''
    fieldName = 'XX-MN.ATM.TRAN.QTY'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY POS PURCHASE LIMIT
    neighbour = ''
    fieldName = 'XX-DA.POSWDL.LIM'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MAXIMUM AMOUNT PER POS PURCHASE
    neighbour = ''
    fieldName = 'XX-MX.POS.TRAN.LIM'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY QUANTITY OF POS PERCHASE
    neighbour = ''
    fieldName = 'XX-DA.POS.TRAN.QTY'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MONTHLY QUANTITY OF POS PURCHASE
    neighbour = ''
    fieldName = 'XX>MN.POS.TRAN.QTY'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX.ADD.CARD.1'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX<AVG.BAL.FROMA'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-AVG.BAL.TOA'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-MTHLY.AC.AVG.BALA'
    fieldLength = '30'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-LIMIT.VALID.UNTILA'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MONTHLY QUANTITY OF ATM TRANSACTION
    neighbour = ''
    fieldName = 'XX-MN.ATM.TRAN.QTYA'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY POS PURCHASE LIMIT
    neighbour = ''
    fieldName = 'XX-DA.POSWDL.LIMA'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MAXIMUM AMOUNT PER POS PURCHASE
    neighbour = ''
    fieldName = 'XX-MX.POS.TRAN.LIMA'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*DAILY QUANTITY OF POS PERCHASE
    neighbour = ''
    fieldName = 'XX-DA.POS.TRAN.QTYA'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*MONTHLY QUANTITY OF POS PURCHASE
    neighbour = ''
    fieldName = 'XX>MN.POS.TRAN.QTYA'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
****************************************************************************************************

    fieldName='RESERVED.20'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.19'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.18'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.17'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.16'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.15'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.14'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.13'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.12'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.11'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.10'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.9'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.8'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.7'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.6'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.5'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.4'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
