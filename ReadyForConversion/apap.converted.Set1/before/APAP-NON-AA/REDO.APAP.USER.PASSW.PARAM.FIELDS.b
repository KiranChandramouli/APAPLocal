*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
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
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.N = '35'    ; ID.T = '':FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'USER.PASSWORD.OT'       ; fieldLength = '16'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    fieldName = 'USER.PASSWORD.GEN'        ; fieldLength = '16'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX.REPORT.USER'        ; fieldLength = '20'     ; fieldType = 'ANY'                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('USER')

    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
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
