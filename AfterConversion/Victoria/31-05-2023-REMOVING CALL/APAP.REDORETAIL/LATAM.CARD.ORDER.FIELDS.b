* @ValidationCode : MjotMTE1MjY5MzU0MjpDcDEyNTI6MTY4NTUzNTg3MzkyNzp2aWN0bzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:54:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.FIELDS
*-----------------------------------------------------------------------------
* Field Definitions for LATAM.CARD.ORDER template
*---------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference            Description
*  10-AUG-2010        Anies              ODR-2009-12-0264    Additional fields have been added
*  22-Sep-2010        Kavitha            ODR-2009-12-0264    Changed to R09 standards
*  13-MAY-2011        KAVITHA            ODR-2010-08-0467    PACS00055017  FIX
*  23-MAY-20111       Prabhu             PACS00062260        CANC.REASON to be multi valued and CANCELLATION.DATE to be no input
*  16 JUN 2011        KAVITHA            PACS00072694        ADDED PROSPECT DETAILS
*  27 JUL 2011        KAVITHA            PACS00093181        PACS00093181 FIX
*  1 AUG 2011         KAVITHA            PACS00094452        PACS00094452 FIX
*  4 AUG 2011         KAVITHA            PACS00094453        PACS00094453 FIX
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION          CALL RTN METHOD ADDED
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
    C$NS.OPERATION = 'ALL'

*-----------------------------------------------------------------------------
*    CALL Table.defineId("LATAM.CARD.ORDER", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '21.1'
    ID.T = "A"   ;

    neighbour = ''
    fieldName = 'CARD.STATUS'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CARD.STATUS')

    neighbour = ''
    fieldName = 'XX.ACCOUNT'
    fieldLength = '16.1'
    fieldType = 'ACC'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    neighbour = ''
    fieldName = 'CURRENCY'
    fieldLength = '3'
    fieldType = 'CCY'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

    neighbour = ''
    fieldName = 'ISSUE.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'EXPIRY.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.NAME'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PIN.ISSUE.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LIMIT'
    fieldLength = '19'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CANCELLATION.DATE'
    fieldLength = '11'
    fieldType = 'D':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'XX.CAN.REASON'
    fieldLength = '35'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    GOSUB NEXT.FIELD.DEF1
    GOSUB ADD.LOC.FIELDS
    GOSUB ADD.LOC.FIELDS.TWO
    GOSUB BPCR.ADDL.FIELDS
*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.FIELDS.SPLIT
    APAP.REDORETAIL.latamCardOrderFieldsSplit();* MANUAL R22 CODE CONVERSION

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*--------
NEXT.FIELD.DEF1:

    neighbour = ''
    fieldName = 'CHARGES'
    fieldLength = '19'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CHARGE.DATE'
    fieldLength = '11'
    fieldType = 'D'
    fieldType<3> = "NOCHANGE"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.NOTES'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName='XX.LOCAL.REF'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'STOCK.REG.ID'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'STOCK.SERIERS.ID'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3> = "NOCHANGE"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LST.REPAY.DATE'
    fieldLength = '11'
    fieldType = 'D'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LST.BILLING.CLOSE'
    fieldLength = '11'
    fieldType = 'D'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'REPAY.DATE'
    fieldLength = '17'
    fieldType = 'FQU'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BILLING.CLOSE'
    fieldLength = '17'
    fieldType = 'FQU'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'NEW.REPAY.DATE'
    fieldLength = '17'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'NEW.BILLING.CLOSE'
    fieldLength = '17'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'ORIG.REPAY.DATE'
    fieldLength = '17'
    fieldType = ''
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'ORIG.BILLING.CLOSE'
    fieldLength = '17'
    fieldType = ''
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CARD.START.NO'
    fieldLength = '20'
    fieldType = ''
    fieldType<3> = "NOCHANGE"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-------------------------------------------------------------------------------------------
ADD.LOC.FIELDS:

*PACS00055017-S
    neighbour = ''
    fieldName = 'TYPE.OF.CARD'
    fieldLength = '35.1'
    fieldType = ''
    virtualTableName='TYPE.OF.CARD'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00055017-E

    neighbour = ''
    fieldName = 'XX<CARD.NUMBER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CUSTOMER.NO'
    fieldLength = '15'
    fieldType = ''
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CUSTOMER')

*PACS00094453-S
    neighbour = ''
    fieldName = 'XX-NAME.ON.PLASTIC'
    fieldLength = '21'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00094453-E

    neighbour = ''
    fieldName = 'XX-ACCOUNT.OFFICER'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

    neighbour = ''
    fieldName = 'XX-DELIVERY.PLACE'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('LATAM.CARD.DELIVERY.ADDRESS')

    neighbour = ''
    fieldName = 'XX-CU.LEGAL.NUMBER'
    fieldLength = '40'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CARDHOLDER.NAME'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CARDHOLDER.LAST'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX>DELIVERY.ADD'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00094452-S

    neighbour = ''
    fieldName = 'TYPE.OF.ISSUE'
    fieldLength = '35'
    fieldType = ''
    virtualTableName='TYPE.OF.ISSUE'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    neighbour = ''
    fieldName = 'ISSUE.STAGE'
    fieldLength = '35.1'
    fieldType = ''
    virtualTableName='ISSUE.STAGE'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    neighbour = ''
    fieldName = 'BLOCK.STATUS'
    fieldLength = '35'
    fieldType = ''
    virtualTableName='BLOCK.STATUS'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

RETURN
*-------------------------------------------------------------------------------------------
ADD.LOC.FIELDS.TWO:

    neighbour = ''
    fieldName = 'TYPE.OF.BLOCK'
    fieldLength = '35'
    fieldType = ''
    virtualTableName='TYPE.OF.BLOCK'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*PACS00094452 -E
    neighbour = ''
    fieldName = 'DATE.SENT.EMBOSS'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DATE.RECEIVE.EMB'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DATE.CARD.SENT'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DATE.DELIVERED'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00094452-S

    neighbour = ''
    fieldName = 'TYPE.OF.MODIFY'
    fieldLength = '55'
    fieldType = ''
    virtualTableName='TYPE.OF.MODIFY'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00094452-E

    neighbour = ''
    fieldName = 'TRANSACTION.FEES'
    fieldLength = '15'
    fieldType = ''
    fieldType<2> = "YES_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CLASS.CODE'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DATE.LIMIT.CONTROL'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LIMIT.CONTROL'
    fieldLength = '15'
    fieldType = ''
    fieldType<2> = "YES_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LIMIT.CONTROL.AMT'
    fieldLength = '25'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'FREQ.LIMIT.CONTROL'
    fieldLength = '15'
    fieldType = ''
    fieldType<2> = "DAILY_WEEKLY_MONTHLY_YEARLY"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CATEGORY.CARD'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CARD.TYPE'
    fieldLength = '15'
    fieldType = 'A'
    fieldType<3> = "NOINPUT"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CARD.TYPE')
*PACS00094452-S

    neighbour = ''
    fieldName = 'ISSUE.INDICATOR'
    fieldLength = '15'
    fieldType = ''
    virtualTableName='ISSUE.INDICATOR'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    neighbour = ''
    fieldName = 'ISSUE.NUMBER'
    fieldLength = '35'
    fieldType = ''
    virtualTableName='ISSUE.NUMBER'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00094452 -E

    neighbour = ''
    fieldName = 'REISS.REASON'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'ACTIVE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PREV.BLOCK.CARD'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'FLAT.CHG.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BRANCH.APPD.CRL'
    fieldLength = '5'
    fieldType = ''
    fieldType<2> = "300_301_302"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'BRANCH.CRD.DEL'
    fieldLength = '9'
    fieldType = ''
    fieldType<2> = "300_301_302"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-------------------------------------------------------------------------------------------
BPCR.ADDL.FIELDS:

    neighbour = ''
    fieldName = 'EMBOSS.TYPE'
    fieldLength = '1'
    fieldType = ''
*PACS00055017-S
    virtualTableName='EMBOSS.TYPE'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00055017-E

    neighbour = ''
    fieldName = 'APPLY.PERIOD.CHG'
    fieldLength = '5'
    fieldType = ''
    fieldType<2> = 'YES_NO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEWAL.FLAG'
    fieldLength = '1'
    fieldType = ''
    fieldType<2> = 'Y_N'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEWAL.NOTES'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PIN.BLOCK'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'OFFSET'
    fieldLength = '12'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'TXN.AMT.TODAY'
    fieldLength = '19'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'LAST.TXN.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'REISSUE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PIN.ERR.RETRYNO'
    fieldLength = '2'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00093181-S
    neighbour = ''
    fieldName = 'RENEW.STATUS'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEW.ISS.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEW.EXP.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'RENEW.REQ.ID'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00093181-E

    neighbour = ''
    fieldName = 'LAST.AUTHEN.DT'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PIN.ISSUE.SEQ'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PIN.ISSUE.USER'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('USER')
*PACS00093181-S

    neighbour = ''
    fieldName = 'RENEWAL.COUNTER'
    fieldLength = '25'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00093181-E
    neighbour = ''
    fieldName = 'PIN.CHG.CUST.DT'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-----------------------------------------------------------------------------
END
