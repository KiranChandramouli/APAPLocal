SUBROUTINE REDO.WOF.ACCOUNTING.FIELDS

*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu
* Program Name  : REDO.WOF.ACCOUNTING.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.AA.NAB.ACCOUNTING
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017     26-FEB-2011          Initial draft
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId('ID', T24_String)
*-----------------------------------------------------------------------------

    fieldName = 'WOF.AMT'
    fieldLength = '10'
    fieldType = 'IN2AMT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'LOAN.STATUS'
    fieldLength = '2'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'PRODUCT'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('AA.PRODUCT')

RETURN
