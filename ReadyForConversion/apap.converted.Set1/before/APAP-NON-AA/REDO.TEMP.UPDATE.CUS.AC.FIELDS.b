*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TEMP.UPDATE.CUS.AC.FIELDS

*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.TEMP.UPDATE.CUS.AC.FIELDS
* ODR NUMBER    : ODR-2009-10-0795
*-------------------------------------------------------------------------
* Description   : This is Template routine will define the template type
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-01-2011      MARIMUTHU s     ODR-2009-10-0795   Initial Creation
*-------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.F = '@ID'
  ID.N = '15'
  ID.T = ''
*-----------------------------------------------------------------------------
  fieldName = 'XX.AC.ID'
  fieldLength = '25'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'XX.AC.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'SAME.CUST'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
