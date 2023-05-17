SUBROUTINE REDO.CIUU.LOAN.DESTINATION.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Template Name : REDO.CIUU.LOAN.DESTINATION.FIELDS

*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.CIUU.LOAN.DESTINATION'
*-----------------------------------------------------------------------------
* Input/Output :
*--------------------------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------

*  DATE             WHO        REFERENCE             DESCRIPTION
* 21-06-2010      PREETHI MD   ODR-2009-10-0326 N.3  INITIAL CREATION

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CATEGORY.CIUU
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ACC.DES.ID", T24_Numeric)  ;* Define Table id
    ID.F = 'ACC.DES.ID'
    ID.N = '2'


*-----------------------------------------------------------------------------


    fieldName="DEST.DESC"
    fieldLength="300"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX.CATEG.CIUU"
    fieldLength="5"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.CATEGORY.CIUU":@FM:CAT.CIU.DESCRIPTION)

    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

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
