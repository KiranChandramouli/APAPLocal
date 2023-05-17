*
    *-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.RIEN3.CONCAT.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.RIEN3.CONCAT.FIELDS
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

    ID.F = '@ID'  ;  ID.N= '35' ;ID.T = 'A'       ;* Included fields type

    fieldName="TXN.REF.AMT"
    fieldLength='65'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    RETURN
*----------------------------------------------------------------------------
END
