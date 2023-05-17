*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LOAN.DOCUMENTATION.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Template Name : REDO.LOAN.DOCUMENTATION.FIELDS

*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.LOAN.DOCUMENTATION'
*-----------------------------------------------------------------------------
* Input/Output :
*-----------------
* IN : NA
* OUT : NA
*------------------

*Modification History :

*------------------------------

*  DATE             WHO        REFERENCE             DESCRIPTION
* 21-06-2010      PREETHI MD   ODR-2009-10-0326 N.3  INITIAL CREATION

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.AA.PRODUCT
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("DOC.CODE",T24_Numeric)     ;* Define Table id
  ID.F = 'DOC.CODE'
  ID.N = '4'

*-----------------------------------------------------------------------------


  fieldName="NAME.DOC"
  fieldLength="300"
  fieldType="ANY"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  neighbour = ''
  fieldName = 'XX<PRODUCT'
  fieldLength = '45'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("AA.PRODUCT")
*
  CALL Table.addOptionsField("XX>PRODUCT.INPUT","MANDATORIO","","")
*

  CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")


  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<3> = 'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
