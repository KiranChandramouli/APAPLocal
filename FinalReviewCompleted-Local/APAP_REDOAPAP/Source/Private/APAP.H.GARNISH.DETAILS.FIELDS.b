* @ValidationCode : MjoxNTU5MDg4NTUwOkNwMTI1MjoxNjgxMTkwMzc3MzMwOmFqaXRoOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:49:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.GARNISH.DETAILS.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*** DATE           BY    ISSUE                DESC
***08-04-2011   PRABHU  PACS00023885        Fields for accounts,available Balance and garnishment amount added
***16-08-2011   Prabhu  PACS00103352        EB.LOOKUP added
***16-09-2011   Prabhu  PACS00133294        FIELDS FROM ACC.ELIMINATION TO LOCKED.DEL.TYPE is made as ASSOCIATED SET
***20-10-2011   Prabhu  PACS00146120        FIELD DETAILS
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F="GARNISH.REF.NO"
    ID.N="12"
    ID.T="A"
*-----------------------------------------------------------------------------
    fieldName ="INDIVIDUAL.NAME"
    fieldLength="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="IDENTITY.TYPE"
*    fieldLength ="8"
*    fieldType="":FM:"ID CARD_PASSPORT_RNC"
    neighbour=""
*    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    virtualTableName='GAR.IDENTITY.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName ="IDENTITY.NUMBER"
    fieldLength ="25"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="GARNISHMENT.AMT"
    fieldLength ="19"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="NO.OF.LEGAL.ACT"
    fieldLength ="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="DATE.LEGAL.ACT"
    fieldLength ="10"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="GARNISHM.TYPE"
    fieldLength ="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="GARNISH.REASON"
    fieldLength ="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="NAME.CREDITOR"
    fieldLength ="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="ID.TYPE"
*    fieldLength ="8"
*    fieldType="":FM:"ID CARD_PASSPORT_RNC"
    neighbour=""
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='GAR.ID.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName ="ID.NUMBER"
    fieldLength ="25"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="CUSTOMER"
    fieldLength ="15"
    fieldType="CUS"
    neighbour=""
    fileName='CUSTOMER'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile(fileName)

    fieldName ="TYPE.OF.LOCKED"
*    fieldLength ="25"
*    fieldType="":FM:"Garnishment_Pledge"
    neighbour=""
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='GAR.TYPE.OF.LOCKED'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName ="AMOUNT.LOCKED"
    fieldLength ="19"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="ACCOUNT.LOCKED"
    fieldLength ="19"
    fieldType="POSANT"
    neighbour=""
    fileName='ACCOUNT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile(fileName)


    fieldName ="XX<ACC.ELIMINATION"
    fieldLength ="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-DATE.ELIMINATON"
    fieldLength ="10"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-GARNISH.AMT.DEL"
    fieldLength ="19"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-SPL.REL.RECORDS"
    fieldLength ="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX>LOCKED.DEL.TYPE"
*    fieldLength ="40"
*    fieldType="":FM:"Garnishment deletion_Partial Deletion_Extraordinary Release Unpledged_Payment to Garnishment creditor"
    neighbour=""
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='GAR.LOCKED.DEL.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName ="UNLOCKED.AMT"
    fieldLength ="19"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX<BENEFICIARY"
    fieldLength ="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-PAYMENT.AMT"
    fieldLength ="19"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-PAYMENT.DESC"
    fieldLength ="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX>COMMENTS"
    fieldLength ="75"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="GARNISHMENT.REF"
    fieldLength ="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX<ACCOUNT.NO"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    fileName='ACCOUNT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile(fileName)

    fieldName ="XX-AVAIL.BAL"
    fieldLength ="35"
    fieldType="AMT":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-GARNISH.AMT"
    fieldLength ="35"
    fieldType="AMT":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName ="XX-ALE.REF"
    fieldLength ="35"
    fieldType="A":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX>XX.REL.AMT"
    fieldLength ="35"
    fieldType="AMT":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="ACCT.STATUS"
    fieldLength ="35"
    fieldType=""
    neighbour=""
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='REDO.GAR.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName ="XX<FIT.ACC"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX-XX.FIT.ALE"
    fieldLength ="35"
    fieldType="AMT":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX>FIT.USED"
    fieldLength ="35"
    fieldType="AMT":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="FIT.AMOUNT.REQ"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
*    virtualTableName='REDO.FIT.RELEASE'
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RECEP.DATE"
    fieldLength ="35"
    fieldType = "A":@FM:"FM":"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*fieldName ="RESERVED.5"
*fieldLength ="35"
*fieldType="":FM:"":FM:"NOINPUT"
*neighbour=""
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.4"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.3"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.2"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="RESERVED.1"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.LOCAL.REF"
    fieldLength ="35"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.STMT.NO"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.OVERRIDE"
    fieldLength ="35"
    fieldType="":@FM:"":@FM:"NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
END
