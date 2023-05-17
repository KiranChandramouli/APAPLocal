SUBROUTINE REDO.APAP.USER.LIMITS.FIELDS
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for template REDO.APAP.USER.LIMITS
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                   Reference              Description
* 08-NOV-2010    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
* 08-APR-2011    Pradeep S             PACS00036002           Changed the char type for
*                                                             SC.LIMIT.DATE & MM.LIMIT.DATE
* 04-May-2011    Pradeep S             PACS00037714           Adding few more fields for USD currency
*                                                             transactions
* 29-Oct-2011    Pradeep S             PACS00153530           TRADER.LIM - Max char changed to 4 from 2
*----------------------------------------------------------------------------------------------------
*** <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.T = 'A' ; ID.N = '35' ; ID.F = '@ID' ; ID.CHECKFILE = 'USER'
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'XX<APPLICATION'
*fieldOptions  = 'FX_MM_SC'
    fieldLength = '2.1'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*CALL Table.addOptionsField(fieldName,fieldOptions,Field_Mandatory,'')
    CALL Field.setCheckFile('EB.PRODUCT')

    neighbour = ''
    fieldName = 'XX-SIN.TXN.LIM.AMT'
    fieldLength = '18'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00037714 - S
    neighbour = ''
    fieldName = 'XX-SIN.TXN.LIM.USD'
    fieldLength = '18.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00037714 - E

    neighbour = ''
    fieldName = 'XX-SIN.TXN.LIM.DATE'
    fieldLength = '11.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-TOT.TXN.LIM.AMT'
    fieldLength = '30'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00037714 - S
    neighbour = ''
    fieldName = 'XX-TOT.TXN.LIM.USD'
    fieldLength = '30.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00037714 - E

    neighbour = ''
    fieldName = 'XX-TOT.TXN.LIM.DATE'
    fieldLength = '11.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-TRADER.LIM'
    fieldLength = '4.1'         ;* PACS00153530 - S/E
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-TRA.LIM.VALID.DATE'
    fieldLength = '11.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-DLY.TOT.TXN.AMT'
    fieldLength = '30'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00037714 - S
    neighbour = ''
    fieldName = 'XX>DLY.TOT.TXN.USD'
    fieldLength = '30'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00037714 - E

    neighbour = ''
    fieldName = 'BPS.LIMIT'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BPS.LIM.VALID.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'MM.LIMIT.DATE'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'SC.LIMIT.DATE'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00037714 - S
    neighbour = ''
    fieldName = 'CURR.MKT'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY.MARKET')
*PACS00037714 - E
    neighbour = ''
    fieldName = 'XX.USR.EMAIL'
    fieldLength = '65'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)




*-----------------------------------------------------------------------------
*    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*-----------------------------------------------------------------------------

    CALL Table.addLocalReferenceField(XX.LOCAL.REF)

    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
