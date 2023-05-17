SUBROUTINE REDO.GL.H.EXTRACT.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.H.EXTRACT.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.GL.H.EXTRACT.PARAMETER
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21 Oct 2010    Shiva Prasad Y      ODR-2009-12-0294 C.12      Initial Creation
*21  JUN 2011    Prabhu N            PACS00032519               field added to store back up path
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'XX<XX.REPORT.NAME'        ; fieldLength = '10.1'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('RE.STAT.REPORT.HEAD')
    fieldName = 'XX-N.GL.IND'           ; fieldLength = '10.1'   ; fieldType = ''                          ;  GOSUB ADD.FIELDS
    fieldName = 'XX-GL.DESCRIPTION'     ; fieldLength = '10.1'   ; fieldType = ''                          ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXTRACT.OUT.PATH'   ; fieldLength = '65.1'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-REPORT.AL'          ; fieldLength = '3.1'    ; fieldType = '':@FM:'BTH_LCY_FCY'         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-REPORT.PL'          ; fieldLength = '3.1'    ; fieldType = '':@FM:'BTH_LCY_FCY'         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-DETAIL.TYPE'        ; fieldLength = '4'      ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-APPLICATION'        ; fieldLength = '35'     ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('PGM.FILE')
    fieldName = 'XX-FIELD'              ; fieldLength = '35'     ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-BAL.ENTRY.NO'       ; fieldLength = '35'     ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-BALANCE.FILE'       ; fieldLength = '3.1'    ; fieldType = '':@FM:'YES_NO'              ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX.STMT.TXN.CODE'   ; fieldLength = '3'      ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TRANSACTION')
    fieldName = 'XX-XX.RECSLE.TXN.CODE' ; fieldLength = '3'      ; fieldType = 'A'                          ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('RE.TXN.CODE')
    fieldName = 'XX-XX.CATEG.TXN.CODE'  ; fieldLength = '3'      ; fieldType = 'A'                          ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TRANSACTION')
    virtualTableName = 'GIT.ROUTINE'
    CALL EB.LOOKUP.LIST(virtualTableName)
    fieldName = 'XX-GIT.ROUTINE'        ; fieldLength = '65.1'   ; fieldType = virtualTableName            ;  GOSUB ADD.FIELDS
    fieldName = 'XX-TYPE.OF.EXTRACT'    ; fieldLength = '10.1'   ; fieldType = '':@FM:'DETAIL_SUMMARY'      ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXT.CURRENCY'       ; fieldLength = '3.1'    ; fieldType = '':@FM:'ALL_LCY_FCY'         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXTRACT.NAME'       ; fieldLength = '65.1'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'XX-DEBIT.FORMAT'       ; fieldLength = '1'      ; fieldType = '':@FM:'+_-'                 ;  GOSUB ADD.FIELDS
    fieldName = 'XX-CREDIT.FORMAT'      ; fieldLength = '1'      ; fieldType = '':@FM:'+_-'                 ;  GOSUB ADD.FIELDS
    fieldName = 'XX>RETEN.PERIOD'       ; fieldLength = '10'     ; fieldType = '':@FM:'DAY_WEEK_MONTH_FORTNIGHT_QUARTER_HALF YEAR'  ;  GOSUB ADD.FIELDS
    fieldName = 'EXT.DEBIT.CODE'        ; fieldLength = '10.1'   ; fieldType = ''                          ;  GOSUB ADD.FIELDS
    fieldName = 'EXT.CREDIT.CODE'       ; fieldLength = '10.1'   ; fieldType = ''                          ;  GOSUB ADD.FIELDS
    fieldName = 'EXT.FILE.EXTN'         ; fieldLength = '10.1'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'BACKUP.PATH'         ; fieldLength = '20'   ; fieldType = 'ANY'                         ;  GOSUB ADD.FIELDS
    fieldName = 'HD.ID.MARKER'        ; fieldLength = '20'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'COM.ID.MARKER'       ; fieldLength = '20'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'DET.ID.MARKER'       ; fieldLength = '20'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    fieldName = 'DET.FILE.EXTN'       ; fieldLength = '20'   ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
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
