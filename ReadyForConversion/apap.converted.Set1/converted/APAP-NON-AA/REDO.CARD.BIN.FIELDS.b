SUBROUTINE REDO.CARD.BIN.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTION:
*------------
* This is field template definition routine to create the REDO.CARD.BIN
* It contains the table definitions
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
*  Date           Who                    Reference            Description
*  19-JUL-2010    SWAMINATHAN.S.R        ODR-2010-03-0400     INITIAL VERSION
*  08-DEC-2010    H GANESH               ODR-2010-08-0469     Added new fields for B166.B
*  07.05.2013     LFPAZMINO                                   VPlus Interface
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*    CALL Table.defineId("REDO.CARD.BIN", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '6.6'
    ID.T = ""   ;

    neighbour = ''
    fieldName = 'XX.DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BIN.STATUS'
    fieldLength = '15'
    fieldType = '':@FM:'ACTIVE_INACTIVE'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setDefault("ACTIVE")

    neighbour = ''
    fieldName = 'ENTITY.ID'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

***********************************
* Added the below fields for B.166B
***********************************

    fieldName = 'BIN.TYPE'
    fieldLength = '6.1'
    fieldType = ''
    fieldType<2> = 'CREDIT_DEBIT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* Changing the card type as multivalue for issue PACS00033279

    fieldName = 'XX.CARD.TYPE'
    fieldLength = '4'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* Change end the card type as multivalue for issue PACS00033279

    fieldName = 'NATIONAL.MARK'
    fieldLength = '3.1'
    fieldType = ''
    fieldType<2> = 'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CORP.MARK'
    fieldLength = '3'
    fieldType = ''
    fieldType<2> = 'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'BIN.OWNER'
    fieldLength = '8.1'
    fieldType = ''
    fieldType<2> = 'APAP_NON.APAP'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*********************************************
* Added the below fields for VPlus Interface
*********************************************

    fieldName = 'XX<ORG.ID'
    fieldLength = '3'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-T24.CURRENCY'
    fieldLength = '3'
    fieldType = 'CCY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName = 'XX>VP.CURRENCY'
    fieldLength = '3'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MERCHANT.NUMBER'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* End of added fields for VPlus

    fieldName = 'RESERVED.11'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESERVED.10'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.9'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.8'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.7'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.6'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.5'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.4'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.3'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.2'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'RESERVED.1'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'A' : @FM : '' : @FM : 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
