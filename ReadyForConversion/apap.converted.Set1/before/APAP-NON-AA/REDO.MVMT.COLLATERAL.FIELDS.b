*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MVMT.COLLATERAL.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.MVMT.COLLATERAL.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.MVMT.COLLATERAL.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ------------
* 15 FEB 2012      ganesh R           ODR-2010-03-0103        Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
  GOSUB ID
  GOSUB FIELDS
  RETURN

ID:
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '35'
  ID.T = 'A'
  RETURN

FIELDS:
  neighbour = ''
  fieldName = 'COLL.ID'         ; fieldLength = '18' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.VAL.DATE'    ; fieldLength = '11' ; fieldType = 'D'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.MVMT.TYPE'   ; fieldLength = '30' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.REAS.MVMT'   ; fieldLength = '35' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.LOC.STAT'    ; fieldLength = '30' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.RESP.MVMT'   ; fieldLength = '25' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'COL.COL.CODE'    ; fieldLength = '19' ; fieldType = 'A'   ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("COLLATERAL.CODE")
  fieldName = 'L.GTEE.DOC'      ; fieldLength = '4'  ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'OUTSTANDING.BAL' ; fieldLength = '18' ; fieldType = 'AMT' ; GOSUB ADD.FIELDS
  fieldName = 'DISBURSE.AMT'    ; fieldLength = '18' ; fieldType = 'AMT' ; GOSUB ADD.FIELDS
  fieldName = 'DISBURSE.DATE'   ; fieldLength = '11' ; fieldType = 'D'   ; GOSUB ADD.FIELDS
  fieldName = 'PRO.TYPE'        ; fieldLength = '35' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'XX.PRE.LOA.NO'      ; fieldLength = '17' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
  fieldName = 'LOAN.NUMBER'     ; fieldLength = '17' ; fieldType = 'A'   ; GOSUB ADD.FIELDS

  CALL Table.addReservedField('RESERVED.20')
  CALL Table.addReservedField('RESERVED.19')
  CALL Table.addReservedField('RESERVED.18')
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

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
