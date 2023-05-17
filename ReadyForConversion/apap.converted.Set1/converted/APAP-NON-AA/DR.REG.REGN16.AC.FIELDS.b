SUBROUTINE DR.REG.REGN16.AC.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.REGN16.AC
*-----------------------------------------------------------------------------
*Description       :Table will hold the file details
*In  Parameter     : N/A
*Out Parameter     : N/A
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
* 29-Jan-2014 - New - Gangadhar.S.V.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    ID.F = '@ID'  ;  ID.N= '35' ;ID.T = 'A'         ;* Included fields type

    fieldName = 'MID.VAL.RATE'
    fieldLength = '20'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
RETURN
*----------------------------------------------------------------------------
END
