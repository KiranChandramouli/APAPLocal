*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CUST.SOLICITUD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* PACS00051761
* APAP - Fabrica de Credito
* CONCAT FILE > Customer - Solicitud (Fields Definition)
* @author lpazminodiaz@temenos.com
* @stereotype Concat File
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
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("CUSTOMER.ID", T24_String)  ;* Define Table id
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'XX.FCSOL.ID'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

END
