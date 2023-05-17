SUBROUTINE REDO.CATEGORY.CIUU.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name  : REDO.CATEGORY.CIUU.FIELDS

*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.CIUU.LOAN.DESTINATION'
*-----------------------------------------------------------------------------
* Input/Output :
*-----------------
* IN : NA
* OUT : NA
*------------------
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------

*  DATE             WHO        REFERENCE             DESCRIPTION
* 21-06-2010      PREETHI MD   ODR-2009-10-0326 N.3  INITIAL CREATION



*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("CATEGORY", T24_String)     ;* Define Table id
    ID.F = 'CATEGORY'
    ID.N = '4'

*-----------------------------------------------------------------------------

    fieldName="XX<DESCRIPTION"
    fieldLength="300"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


    fieldName="XX-DIVISION"
    fieldLength="4"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-GROUP"
    fieldLength="5"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX>BRANCH"
    fieldLength="6"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="CATEGORIA"
    fieldLength="4"
    fieldType=""
    neighbour = ""
    virtualTableName='CATEGORIA'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


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
