*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.AA.UNC.PENDING.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.AA.UNC.PENDING
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
* Development by  : Edwin Charles D
* Date            : 21 Agosto 2017
*
* ------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*************************************************************************

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'ARR.STATUS'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
END
