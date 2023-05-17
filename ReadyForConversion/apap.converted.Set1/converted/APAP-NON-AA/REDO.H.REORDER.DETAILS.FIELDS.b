SUBROUTINE REDO.H.REORDER.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template field definition for REDO.H.REORDER.DETAILS
*----------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.H.REORDER.DETAILS.FIELDS
*----------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  GANESH R     ODR-2009-11-0200  INITIAL CREATION


*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.H.REORDER.DETAILS", T24_String) ;* Define Table id
    ID.F = '@ID'
    ID.N = '36'
    ID.T = 'A'
    ID.CHECKFILE='COMPANY'
*-----------------------------------------------------------------------------
    fieldName = 'XX-REORDER.ITEM'
    fieldLength = '36'
    fieldType = 'A'
    neighbour =''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>QTY.TO.ORD'
    fieldLength = '36'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
