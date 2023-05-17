*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTRF.REP.LINE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INTRF.REP.LINE.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.INTRF.REP.LINE
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 Oct 2010    Shiva Prasad Y      ODR-2009-12-0294 C.12      Initial Creation
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '15'    ; ID.T = 'A' ; ID.CHECKFILE = 'RE.STAT.REP.LINE'
*-----------------------------------------------------------------------------
  neighbour = ''

  fieldName = 'LINE.BALANCE'          ; fieldLength = '10'     ; fieldType = '':FM:'DETAIL_SUMMARY'      ;  GOSUB ADD.FIELDS
  fieldName = 'XX.DETAIL.TYPE'        ; fieldLength = '10'     ; fieldType = '':FM:'SUMMARY'             ;  GOSUB ADD.FIELDS
  fieldName = 'XX.DESC'               ; fieldLength = '35'     ; fieldType = 'A'                         ;  GOSUB ADD.FIELDS
  fieldName = 'AL.PL'                 ; fieldLength = '2'      ; fieldType = '':FM:'AL_PL'               ;  GOSUB ADD.FIELDS

  fieldName = 'IS.CONTINGENT'         ; fieldLength = '3'      ; fieldType = '':FM:'NO_YES'               ;  GOSUB ADD.FIELDS
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
