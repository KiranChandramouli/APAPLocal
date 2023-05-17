*-----------------------------------------------------------------------------
* <Rating>-93</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DAMAGE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.DAMAGE
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21 Jul 2010    Mohammed Anies K   ODR-2010-03-0400            Initial Creation
* 6 Apr 2011     Kavitha            PACS00052984                Fields added
* 9 May 2011     H Ganesh           PACS00054728                Check file ID has been removed and handled in .ID routine
* 20 May 2011     KAVITHA            PACS00024249                Check file ID Modification
* 16 SEP 2011     KAVITHA            PACS00128961                  PACS00128961 FIX
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '25'    ; ID.T = 'A'
*ID.CHECKFILE = 'REDO.CARD.REQUEST'
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'STOCK.ENTRY.ID'   ; fieldLength = '12'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
*PACS00024249-S
  CALL Field.setCheckFile('REDO.STOCK.ENTRY')
*PACS00024249-E
  fieldName = 'AGENCY'   ; fieldLength = '12'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('COMPANY')
  fieldName = 'XX<CARD.TYPE' ; fieldLength = '15'   ; fieldType = 'A':FM:'':FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CARD.TYPE')
  fieldName = 'XX-CARD.SERIES'      ; fieldLength = '15'   ; fieldType = 'A':FM:'':FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX-CARD.START.NO'    ; fieldLength = '20'   ; fieldType = '':FM:'':FM:'NOINPUT'   ;  GOSUB ADD.FIELDS
  fieldName = 'XX-DATE.REC.BRANCH'  ; fieldLength = '8'    ; fieldType = 'D':FM:'':FM:'NOINPUT'   ;  GOSUB ADD.FIELDS
  fieldName = 'XX-QTY.RECEIVED'     ; fieldLength = '12'   ; fieldType = '':FM:'':FM:'NOINPUT'   ;  GOSUB ADD.FIELDS

*PACS00052984 -S

  fieldName = 'XX-TOT.LOST.DAMAGE'   ; fieldLength = '15'   ; fieldType = '':FM:'':FM:'NOINPUT'     ;  GOSUB ADD.FIELDS

*PACS00128961 -S
  neighbour = ''
  fieldName = 'XX-XX<REASON'
  fieldLength = '15'

  virtualTableName='REASON'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*PACS00128961 -E

  fieldName = 'XX-XX-REMARKS'          ; fieldLength = '25'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX-XX>CARD.NUMBER'      ; fieldLength = '16'   ; fieldType = ''   ;  GOSUB ADD.FIELDS

  neighbour = ''
  fieldName = 'XX-XX<REASON.OLD'
  fieldLength = '15'

  virtualTableName='REASON'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


  fieldName = 'XX-XX-REMARKS.OLD'          ; fieldLength = '25'   ; fieldType = 'A':FM:'':FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX>XX>CARD.NUMBER.OLD'      ; fieldLength = '16'   ; fieldType = '':FM:'':FM:'NOINPUT'   ;  GOSUB ADD.FIELDS

*PACS00052984-E

  CALL Table.addReservedField('RESERVED.17')
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
