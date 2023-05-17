SUBROUTINE REDO.COLL.TYPE.DET.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.COLL.TYPE.DET.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a template routine. This template is used to store the Collateral
*                    document type details
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.N = '35'    ;   ID.T = ''
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'DOCUMENT.TYPE'  ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX.COLLATERAL.TYPE'  ; fieldLength = '35.1'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile("COLLATERAL.TYPE")
*-----------------------------------------------------------------------------
    fieldName = 'RESERVED.05'  ;  fieldType = T24_String ; args = Field_NoInput ;  GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.04'  ;  fieldType = T24_String ; args = Field_NoInput ;  GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.03'  ;  fieldType = T24_String ; args = Field_NoInput ;  GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.02'  ;  fieldType = T24_String ; args = Field_NoInput ;  GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.01'  ;  fieldType = T24_String ; args = Field_NoInput ;  GOSUB ADD.RESERVED.FIELDS
*-----------------------------------------------------------------------------
    CALL Table.addLocalReferenceField('XX.LOCAL.REF')

    CALL Table.addOverrideField

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
********************
ADD.RESERVED.FIELDS:
********************
    CALL Table.addField(fieldName, fieldType, args, neighbour)          ;* Add a new fields

RETURN
*----------------------------------------------------------------------------
END
