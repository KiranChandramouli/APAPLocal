$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.REPORT.SERVICE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Program   Name    : L.APAP.REPORT.SERVICE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template L.APAP.REPORT.SERVICE.PARAM
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'TABLE.DESCRIPTION' ; fieldLength = '100'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX.TSA.SERVICE.NAME'       ; fieldLength = '75'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('BATCH')
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
