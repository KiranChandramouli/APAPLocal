SUBROUTINE REDO.CARD.REQUEST.FIELDS
*-----------------------------------------------------------------------------

*DESCRIPTIONS:
*-------------
* This is field template definition routine to create the REDO.CARD.REQUEST
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
*   Date            Who                    Reference             Description
*  19-JUL-2010    SWAMINATHAN.S.R          ODR-2010-03-0400       INITIAL VERSION
*  08-APR-2011    JEEVA T                  ODR-2010-03-0400       CHANGES FOR ADDDITIONAL CARD
*  13-MAY-2011    KAVITHA                  ODR-2010-08-0467       PACS00055017  FIX
*  21-MAY-2011    GANESH R                 ODR-2010-08-0467       PACS00055017  FIX  ADDED TRANSIT FIELD
*  27 MAY 2011    KAVITHA                  PACS00063156           PACS00063156 FIX
* 10 JUN 2011     KAVITHA                  PACS00063138           PACS00063138 FIX
* 16 JUN 2011     KAVITHA                  PACS00072694           ADDED PROSPECT DETAILS FOR PACS00072694 FIX
* 04 AUG 2011     KAVITHA                  PACS00094453           *PACS00094453 FIX
* 28 Sep 2011     Balagurunathan           PACS00131231           Added fields for renwal purpose
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.REDO.CARD.BIN

*-----------------------------------------------------------------------------
*    CALL Table.defineId("REDO.CARD.REQUEST", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '25'
    ID.T = "A"   ;

    neighbour = ''
    fieldName = 'AGENCY'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COMPANY')

    neighbour = ''
    fieldName = 'XX<CARD.TYPE'
    fieldLength = '15.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CARD.TYPE')

    neighbour = ''
    fieldName = 'XX-BIN'
    fieldLength = '10'
    fieldType = '':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.CARD.BIN')

    neighbour = ''
    fieldName = 'XX-BRANCH.ORDERQTY'
    fieldLength = '7'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-REGOFF.ACCEPTQTY'
    fieldLength = '7'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CARD.SERIES.ID'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CARD.START.NO'
    fieldLength = '55'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-PERS.CARD'
    fieldLength = '10'
*    fieldType = '':FM:'URGENT_REGULAR'
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00055017-S

    virtualTableName='PERS.CARD'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*PACS00055017 -E

    neighbour = ''
    fieldName = 'XX-XX<CUSTOMER.NO'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CUSTOMER')

    neighbour = ''
    fieldName = 'XX-XX-ACCOUNT.NO'
    fieldLength = '19'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

*PACS00094453 -S
    neighbour = ''
    fieldName = 'XX-XX>CUSTOMER.NAME'
    fieldLength = '21'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00094453 -E

    neighbour = ''
    fieldName = 'XX-TYPE.OF.CARD'
    fieldLength = '20'
*    fieldType = '':FM:"PRINCIPAL_ADDITIONAL"
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

**PACS00055017-S

    virtualTableName='TYPE.OF.CARD'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

**PACS00055017-E
*PACS00063138-S
    neighbour = ''
    fieldName = 'XX-VAULT.QTY'
    fieldLength = '55'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00063138-E
    neighbour = ''
    fieldName = 'XX-PRIMARY.CARD'
    fieldLength = '25'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00063156-S
    neighbour = ''
    fieldName = 'XX>COMMENTS'
    fieldLength = '85'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00063156-E

    neighbour = ''
    fieldName = 'STATUS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.CARD.REQ.STATUS')


    neighbour = ''
    fieldName = 'AUTO.REQUEST.FLAG'
    fieldLength = '3'
    fieldType = '':@FM:'YES_'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEWAL.FLAG'
    fieldLength = '3'
    fieldType = '':@FM:'YES_'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour = ''
    fieldName = 'DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setDefault(TODAY)

    neighbour = ''
    fieldName = 'AGENCY.DESC'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName='PRINTING.SE.ID'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='BRANCH.SE.ID'
    fieldLength='35'
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='VAULT.SE.ID'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='SENT.CRD.GEN.REQ'
    fieldLength='3'
    fieldType=''
    fieldType<2>='YES_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='BR.RECEIVE.DATE'
    fieldLength='35'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='TRANSIT.SE.ID'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*PACS00072694-S

    neighbour = ''
    fieldName = 'PROSPECT.ID'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CUSTOMER')

*PACS00072694-E

    fieldName='REQUEST.DESC'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*    fieldName='RESERVED.13'
*    fieldLength='35'
*    fieldType='A':FM:'':FM:'NOINPUT'
*    neighbour=''
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='NUMBERS.GEN'
    fieldLength='3'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.11'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.10'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.9'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.8'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.7'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.6'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.5'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.4'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
