$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.PDT.TYPE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.MODTYPE.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 05/04/10 - EN_10003543
*            New Template changes
* 22/07/11 - UPDATE
*            New fields PRODUCT.TYPE and PRODUCTS added
*            Roberto Mondragon
*            rmondragon@temenos.com
*            RTAM - Latin America
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = '3'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'PRODUCT.NAME'
    fieldLength = '100'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'PRODUCT.TYPE'
    fieldLength = '18'
    fieldType = ''
    fieldType<2> = 'Otro_Ahorro/Certificado_Prestamo_T.Debito'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.PRODUCT'
    fieldLength = '5'
    fieldType = ''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CATEGORY")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
