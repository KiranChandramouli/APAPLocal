* @ValidationCode : MjotMTUxOTIzNDU1ODpDcDEyNTI6MTY4MDYwNTExOTI3ODpJVFNTOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:15:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CLEARING.INWARD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.APAP.CLEARING.INWARD.FIELDS
*
* @author ganeshr@temenos.com
* @stereotype fields template
*Reference No ODR2010090148
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
* 30 -AUG -2011 - PACS00112979  FIX
*-----------------------------------------------------------------------------
* Date                  who                   Reference              
* 04-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '65'
    ID.T = 'A'
*-----------------------------------------------------------------------------

    fieldName="TASK.CLEARING"
    fieldLength="2"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="TRANS.DATE"
    fieldLength="8"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="LOTE"
    fieldLength="10"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="DIN"
    fieldLength="10"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="ACCOUNT.NO"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="CURRENCY"
    fieldLength="3"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('CURRENCY')

    fieldName="ACCT.OFFICER"
    fieldLength="4"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

    fieldName="CUSTOMER.NO"
    fieldLength="15"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('CUSTOMER')

    fieldName = 'CHEQUE.NO'
    fieldLength = '10'
    fieldType = ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'BANK.CODE'
    fieldLength = '9'
    fieldType = ""
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="AMOUNT"
    fieldLength="15"
    fieldType="AMT"
    fieldType<2,2>='6'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="TAX.AMOUNT"
    fieldLength="15"
    fieldType="AMT"
    fieldType<2,2>='6'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="CATEGORY"
    fieldLength="4"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);


    fieldName="CANT.CREDIT"
    fieldLength="4"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);


    fieldName="CANT.DEBIT"
    fieldLength="4"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);


    fieldName="OTH.ROUTE.NO"
    fieldLength="11"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="CHECK.DIGIT"
    fieldLength="4"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="TRANS.REFERENCE"
    fieldLength="24"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="IMAGE.REFERENCE"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'STATUS'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('REDO.CLEARING.STATUS')

    fieldName="XX.REASON"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('REDO.REJECT.REASON')

    fieldName="WAIVE.CHARGES"
    fieldLength="5"
    fieldType=""
    fieldType<2> ="YES_NO"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*PACS00112979 -S
    fieldName="CHARGE.TYPE"
    fieldLength="11"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

*PACS00112979 -E

    fieldName="CHG.AMOUNT"
    fieldLength="25"
    fieldType="AMT"
    fieldType<2,2>='6'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="NARRATIVE"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="REJECT.TYPE"
    fieldLength="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="REFER.DATE.TIME"
    fieldLength="16"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="REFER.NAME"
    fieldLength="10"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName="COMP.CODE"
    fieldLength="10"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);
    CALL Field.setCheckFile('COMPANY')

    CALL Table.addReservedField('RESERVED.19')
    CALL Table.addReservedField('RESERVED.18')
    CALL Table.addReservedField('RESERVED.17')
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
*-----------------------------------------------------------------------------
    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*------------------------------,-----------------------------------------------
END
