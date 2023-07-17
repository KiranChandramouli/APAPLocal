* @ValidationCode : MjoxNjc0OTY0OTQ1OkNwMTI1MjoxNjgwNjc3MjA4MzI5OmFqaXRoOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:16:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.IF02B.EXTRACT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.IF02.EXTRACT.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template DR.REG.IF02.EXTRACT
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 2 May 2013                                                    Initial Creation

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '6'    ; ID.T = '':@FM:'SYSTEM' ;*R22 AUTO CODE CONVERSION
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'XX.LL.DESCRIPTION'     ; fieldLength = '35'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
    fieldName = 'EXTRACT.PATH'          ; fieldLength = '60'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
    fieldName = 'CUSTOMER.NUMBER'       ; fieldLength = '10'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
    fieldName = 'ID.CARD.NUMBER'        ; fieldLength = '10'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
    fieldName = 'COMMUNC.NUMBER'        ; fieldLength = '7.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS
    fieldName = 'COMMUNC.YEAR'        ; fieldLength = '4.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS
    fieldName = 'START.TIME'          ; fieldLength = '8.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS
    fieldName = 'END.TIME'            ; fieldLength = '8.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS

    CALL Table.addReservedField('RESERVED.1')

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
*-----------------------------------------------------------------------------
END
