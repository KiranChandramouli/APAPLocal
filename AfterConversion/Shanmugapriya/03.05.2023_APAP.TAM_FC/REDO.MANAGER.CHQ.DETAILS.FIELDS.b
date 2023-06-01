* @ValidationCode : MjoxOTc1NTc1OTQ3OkNwMTI1MjoxNjgzMDgxNzAxMzk1OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 May 2023 08:11:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.MANAGER.CHQ.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*DATE           WHO              REFERENCE            DESCRIPTION
*08.04.2010    H GANESH          ODR-2009-12-0285     INITIAL CREATION
*09-05-2011    Bharath G         PACS00023918         The BENEFICIARY  field should be multivalue field
*31-05-2011    Bharath G         PACS00071959         Changed to EB.LOOKUP for SPANISH words
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.MANAGER.CHQ.DETAILS", T24_String)         ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = "CHEQUE.NO"
    ID.N = '25'
    ID.T = ''

    neighbour = ''
    fieldName = 'CHEQUE.INT.ACCT'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* CALL Field.setCheckFile('ACCOUNT')

    neighbour = ''
    fieldName = 'STATUS'
    fieldLength = '35'
* PACS00071959 - S
    fieldType = ''
* fieldType<2>='ISSUED_PAID_CANCELLED_REINSTATED_STOP.PAID.CNFRM_STOP.PAID.NON.CNFRM_REISSUED_RECLASSIFY'
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='MGR.CHQ.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
    CALL Field.setDefault('ISSUED')
* PACS00071959 - E

    neighbour = ''
    fieldName = 'AMOUNT'
    fieldLength = '35'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'ISSUE.ACCOUNT'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    neighbour = ''
    fieldName = 'ISSUE.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CANCELLATION.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'REINSTATED.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PAID.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'STOP.PAID.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'STOP.PAID.REASN'
    fieldLength = '35'          ;* PACS00023918
    fieldType = ''    ;* PACS00023918
* PACS00071959 - S
*  fieldType<2>='LOST_STOLEN_DAMAGED'  ;* PACS00023918
*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName = 'MGR.STOP.PAY.RESN'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
* PACS00071959 - E

    neighbour = ''
    fieldName = 'COMPANY.CODE'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COMPANY')

    neighbour = ''
    fieldName = 'XX.BENEFICIARY'          ;* PACS00023918
    fieldLength = '65'          ;* PACS00023918
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'TRANS.REFERENCE'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'TAX.AMT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.USER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.ADDITIONAL.INFO'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'REV.STATUS'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CHQ.SEQ.NUM'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    neighbour = ''
    fieldName = 'XX.STMT.NO'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
