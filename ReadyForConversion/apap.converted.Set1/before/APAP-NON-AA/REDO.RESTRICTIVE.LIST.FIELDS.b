*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RESTRICTIVE.LIST.FIELDS
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
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
  $INSERT I_DataTypes
  $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'ANY'
*-----------------------------------------------------------------------------
  fieldName = 'TIPO.DE.PERSONA'
  fieldLength = '35'
  fieldType = 'A'
*fieldType<2> = 'PERSONA FISICA_PERSONA JURIDICA'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('AC.TIPO.DE.PERSONA')

  fieldName = 'TIPO.DE.DOCUMENTO'
  fieldLength = '35'
  fieldType = 'A'
*fieldType<2> = 'CEDULA_PASAPORTE_RNC'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('AC.TIPO.DE.DOC')


  fieldName = 'NUMERO.DOCUMENTO'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.NOMBRES'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.APELLIDOS'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.RAZON.SOCIAL'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'NACIONALIDAD'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('COUNTRY')

*TableName = 'LIST'
  fieldName = 'XX.LISTA.RESTRICTIVA'
  fieldLength = '35'
  fieldType = 'A'
*
* fieldType<2>='POLICIA NACIONAL_DNCD_INTERPOL_FBI_CIA_CLIENTE NO DESEADO EN APAP'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*CALL Table.addFieldWithEbLookup(fieldName,TableName,neighbour)
  CALL Field.setCheckFile('AC.LISTA.RESTRICTIVA')

*-----------------------------------------------------------------------------
  CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput ,"")
*----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
