SUBROUTINE REDO.MASSIVE.FILE.PATH.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh         Massive rate - B.16  INITIAL CREATION
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '6'
    ID.T = '' ; ID.T<2> = 'SYSTEM'

    fieldName='EXTRACT.PATH'
    fieldLength='65.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='UNPROCESSED.PATH'
    fieldLength='65.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PROCESSED.PATH'
    fieldLength='65.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='EXCEPTION.PATH'
    fieldLength='65.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
