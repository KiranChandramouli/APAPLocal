* @ValidationCode : MjotNDE2Mjk1NTUxOkNwMTI1MjoxNjgxMjc2NTQ4NDI0OklUU1M6LTE6LTE6LTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.FIELDS.SPLIT
*-----------------------------------------------------------------------------

*DESCRIPTION
*-----------
* This is a routine will be called by LATAM.CARD.ORDER.FIELDS
*
*---------------------------------------------------------------------------------------------

* Revision History
*-------------------------
*    Date             Who               Reference          Description
*  12-JAN-2012       KAVITHA            ODR-2009-12-0264   Split up
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.CARD.STATUS
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.LATAM.CARD.DELIVERY.ADDRESS
    $INSERT I_DataTypes

    GOSUB PROCESS

RETURN

*-----------
PROCESS:

    neighbour = ''
    fieldName = 'XX<TYPE.OF.SERVICE'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<2> = "LIGHT_WATER_TELEPHONE"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX>SERVICE.ACCTS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CHANNEL.OPR'
    fieldLength = '15'
    fieldType = 'A'
    fieldType<2> = "INTERNET_IVR_BOTH"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX<UCR.RESPONSE.CODE'
    fieldLength = '2'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX>UCR.RESPONSE.DESC'
    fieldLength = '60'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX<NED.RESPONSE.CODE'
    fieldLength = '2'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX>NED.RESPONSE.DESC'
    fieldLength = '60'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX<UCC.RESPONSE.CODE'
    fieldLength = '2'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX>UCC.RESPONSE.DESC'
    fieldLength = '60'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX<UCA.RESPONSE.CODE'
    fieldLength = '2'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX>UCA.RESPONSE.DESC'
    fieldLength = '60'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'EXPORT.RECORDS'
    fieldLength = '5'
    fieldType = ''
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);


    neighbour = ''
    fieldName = 'XX.RESPONSE.MSG'
    fieldLength = '250'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'EXP.RESPONSE.DESC'
    fieldLength = '60'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='XX.CHANNEL.DENY'
    fieldLength='2'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'ACTIVE.TIME'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='ISSUE.TIME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='CARD.LINKED'
    fieldLength='19'
    fieldType=''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*PACS00072694-S

    neighbour = ''
    fieldName = 'PROSPECT.ID'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CUSTOMER')

*PACS00072694-E

    fieldName='RENEWAL.DATE'
    fieldLength='8'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour = ''
    fieldName = 'RENEW.CARD.LOST'
    fieldLength = '5'
    fieldType = 'A'
    fieldType<2> = "YES_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='REISSUE.COUNTER'
    fieldLength='25'
    fieldType=''
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

    fieldName='XX.STMT.NO'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='XX.OVERRIDE'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

RETURN
*-----------------------------------------------------------------------------
END
