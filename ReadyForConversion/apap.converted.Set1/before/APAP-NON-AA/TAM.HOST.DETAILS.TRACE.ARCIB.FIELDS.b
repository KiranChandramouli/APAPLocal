*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.HOST.DETAILS.TRACE.ARCIB.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : TAM.HOST.DETAILS.TRACE.FIELDS
*-----------------------------------------------------------------------------
*Description       : This is a T24 routine which retrieves the information from the
*                    local table TAM.HOST.DETAILS.TRACE and stores it in the INPUTTER field of the transaction
*                    Attach this Routine in the AUTH.RTN field of VERSION.CONTROL file with SYSTEM as id
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date           Who              Reference          Description
*   -----         ------            -------------       ------------
* 03 Oct  2010    Mudassir V       ODR-2010-08-0465    Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>

*-----------------------------------------------------------------------------
  ID.F = '@ID';  ID.T<1> = 'A';  ID.N = '35'
*-----------------------------------------------------------------------------

  fieldName = 'HOST.NAME'
  fieldLength = '50'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'IP.ADDRESS'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'DATE'
  fieldLength = '16'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
