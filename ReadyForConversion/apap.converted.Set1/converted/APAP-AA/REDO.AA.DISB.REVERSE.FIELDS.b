SUBROUTINE REDO.AA.DISB.REVERSE.FIELDS
*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.DISB.CHAIN
* Attached as     :
* Primary Purpose : Define the fields to table REDO.DISB.CHAIN
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 10 Agosto 2011
*
* Date            : 01-07-2017   - Edwin Charles D - PACS00236823
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*************************************************************************

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'XX<DESB.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-XX<FT.TEMP.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX>XX>FT.TXN.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

RETURN
END
