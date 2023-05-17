*-----------------------------------------------------------------------------
* <Rating>-39</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MULTITXN.VERSIONS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.ABBREVIATION
*
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.CHECKFILE = "ABBREVIATION" : FM : EB.ABB.ORIGINAL.TEXT
*     CALL Field.setCheckFile("VERSION")        ;* Use DEFAULT.ENRICH from SS or just field 1


*-----------------------------------------------------------------------------

  CALL Table.addFieldDefinition("DESCRIPTION", 35, "A", "") ;* Add a new fields

  fieldType = '':FM:'I_E'
  CALL Table.addFieldDefinition("PROC.TYPE", 1, fieldType, "")        ;* Add a new fields

  fieldType = '':FM:'E_C_M'
  CALL Table.addFieldDefinition("RECEP.METHOD", 1, fieldType, "")     ;* Add a new fields

  CALL Table.addFieldDefinition("PRIORIDAD", 2, "", "")     ;* Add a new fields

  CALL Table.addFieldDefinition("AUTOR.NO", 1, "", "")      ;* Numero de Autorizaciones

  fieldName    = 'VERSION.NAME'
  fieldLength  = '55'
  fieldType    = 'A'
  neighbour    = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("VERSION")

  fieldName   = 'VERSION.TYPE'
  fieldLength = '25'
  fieldType   = ''
  fieldType<2>= 'AA.PAYMENT_AA.COLLECTION_NON.AA_CASH_CHEQUE_ACCOUNT.DEBIT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   = 'D.SLIP.NAME'
  fieldLength = '60'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("DEAL.SLIP.FORMAT")

*       CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
  CALL Table.addReservedField('RESERVED.1')       ;* add a neew reserved
  CALL Table.addReservedField('RESERVED.2')       ;* add a neew reserved
  CALL Table.addReservedField('RESERVED.3')       ;* add a neew reserved
*CALL Table.addReservedField('RESERVED.4')     ;* add a neew reserved
*CALL Table.addReservedField('RESERVED.5')     ;* add a neew reserved
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
