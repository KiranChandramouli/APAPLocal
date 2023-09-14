* @ValidationCode : MjoxNDQ3MzQ4MTkyOkNwMTI1MjoxNjgwNjgwNjA3OTUzOklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.EMP.RESP.MVMT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.EMP.RESP.MVMT.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a template routine. This template is used to store the Employee
*                    response movement details
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_Numeric)          ;* Define Table id
    ID.N = '25'    ;   ID.T = ''
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'EMP.NAME'  ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'EMP.POSITION'  ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'ORG.UNIT'  ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS

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
