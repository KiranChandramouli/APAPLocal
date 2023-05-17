*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.EOM.BRANCH.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     :
* Attached as     :
* Primary Purpose : Define the fields used for FT Data Capture
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
* Development by  : Juan Pablo Armas - TAM Latin America
* Date : 26 MAY 2017
* Developed by : Edwin Charles D
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'XX<MONTH'
    fieldLength = '2.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX>AGENT.CODE'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("DEPT.ACCT.OFFICER")

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
END
