SUBROUTINE REDO.VP.PUNISHED.UPLOAD.FIELDS

******************************************************************************
* Company Name    : T24
* Developed By    : Mauricio Sthandier - msthandier@temenos.com
*
* Subroutine Type : T
* Attached to     : REDO.VP.PUNISHED.UPLOAD
* Attached as     : .FIELDS routine
* Primary Purpose : Campos de REDO.VP.PUNISHED.UPLOAD
* Date:           : Jan 2015
*
* Incoming:
* ---------
* N/A
*
* Outgoing:
* ---------
* N/A
*
* Error Variables:
* ----------------
* N/A
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* MSR201405
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE



    ID.F    = '@ID'
    ID.N    = '12'
    ID.T    = 'A'

    fieldName = 'CARD.NUMBER'
    fieldLength = '16'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'CLIENT.NAME'
    fieldLength = '20'
    neighbour = ''
    fieldType = 'CUS'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("CUSTOMER")

    fieldName = 'EFFECTIVE.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'PROCESSING.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'MATURITY.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'TOTAL.AMOUNT'
    fieldLength = '19'
    neighbour = ''
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX<ACTIVITY.STATUS'
    fieldLength = '1'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX>ACTIVITY.MESSAGE'
    fieldLength = '256'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'OVERALL.STATUS'
    fieldLength = '1'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

RETURN

END
