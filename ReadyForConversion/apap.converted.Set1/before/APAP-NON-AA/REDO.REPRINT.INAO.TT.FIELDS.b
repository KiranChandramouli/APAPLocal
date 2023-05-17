*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REPRINT.INAO.TT.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.REPRINT.INAO.TT
*----------------------------------------------------------------------------------------------------
* Description   : Template routine to carry the deal slip information for the reprint
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
* DATE          WHO                  REFERENCE        DESCRIPTION
* 13/06/2013    Vignesh Kumaar R     PACS00290275     REPRINT OPTION FOR THE INAO TT RECORDS
*----------------------------------------------------------------------------------------------------
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
  ID.T<1> = 'A'
*-----------------------------------------------------------------------------

  fieldName = 'XX.HOLD.CTRL.ID'
  fieldLength = '65'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CHQ.PRINTED'
  fieldLength = '3'
  fieldType = '':FM:'YES_NO'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TILL.USER'
  fieldLength = '16'
  fieldType = 'A':FM:FM:'NOCHANGE'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
  fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
  fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
  fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
  fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

* Local reference field
  fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = T24_String ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

* STMT field
  fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

* Override field
  fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

* Audit fields
  GOSUB ADD.AUDIT.FIELDS

  RETURN

*----------------------------------------------------------------------------------------------------------------------

ADD.RESERVED.FIELDS:
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  RETURN

ADD.LOCAL.REF.FIELDS:
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  RETURN

ADD.AUDIT.FIELDS:
  CALL Table.setAuditPosition
  RETURN

*----------------------------------------------------------------------------------------------------------------------

END
