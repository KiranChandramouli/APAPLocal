SUBROUTINE REDO.FC.COLL.CODE.PARAMS.FIELDS


*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.FC.COLL.CODE.PARAMS
* Attached as     :
* Primary Purpose : Define the fields to table REDO.FC.PARAMS
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
* Date            : 08 Junio 2011
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

* CALL Table.defineId("@ID", T24_String)        ;* Define Table id
* CALL Field.setCheckFile("COLLATERAL.CODE")
    ID.F = "@ID" ; ID.N = "3" ; ID.T = ""
*    ID.CHECKFILE = "COLLATERAL.CODE"



*neighbour = ''
    fieldName = 'TIP.REV.TASA'
*fieldLength = '16'
*fieldType = 'A'
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Table.addOptionsField(fieldName,"BACK.TO.BACK_FIJO_PERIODICO","","")


    neighbour = ''
    fieldName = 'PER.MAX.PRESTAR'
    fieldLength = '16'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX.CAMPO.MAND'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
END
