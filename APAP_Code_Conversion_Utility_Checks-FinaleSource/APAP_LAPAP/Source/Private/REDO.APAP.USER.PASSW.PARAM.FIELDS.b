* @ValidationCode : MjoxOTE3MDA0ODY0OkNwMTI1MjoxNjgyMzMxNTY0ODQ2OklUU1M6LTE6LTE6LTEzOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.USER.PASSW.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.USER.PASSW.PARAM.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.APAP.USER.PASSW.PARAM
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*  21.04.2023       Conversion Tool           R22               Auto Conversion     - $INCLUDE T24.BP TO $INSERT, FM TO @FM
*  21.04.2023       Shanmugapriya M           R22               Manual Conversion   - No changes
*

* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON                           ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE                           ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_DataTypes                        ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'USER.PASSWORD.OT'       ; fieldLength = '16'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    fieldName = 'USER.PASSWORD.GEN'        ; fieldLength = '16'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX<REPORT.USER'        ; fieldLength = '20'     ; fieldType = 'ANY'                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('USER')
    fieldName = 'XX-XX<USER.MENU'        ; fieldLength = '45'     ; fieldType = 'ANY'                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('HELPTEXT.MENU')
    fieldName = 'XX>XX>USER.SMS.GRP'        ; fieldLength = '20'     ; fieldType = 'ANY'                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('USER.SMS.GROUP')
    fieldName = 'SERVER.NAME'        ; fieldLength = '15.1'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.setAuditPosition         ;* Poputale audit information
RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

RETURN
*-----------------------------------------------------------------------------
END
