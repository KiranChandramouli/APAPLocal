SUBROUTINE REDO.H.ITEM.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.H.ITEM.DETAILS
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.H.ITEM.DETAILS.FIELDS
*------------------------------------------------------------------------------------------
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
    CALL Table.defineId("REDO.H.ORDER.DETAILS", T24_String)   ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    fieldName = 'XX<SUPPLY.CODE'
    fieldLength = '36'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>DESCRIPTION'
    fieldLength = '100'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
