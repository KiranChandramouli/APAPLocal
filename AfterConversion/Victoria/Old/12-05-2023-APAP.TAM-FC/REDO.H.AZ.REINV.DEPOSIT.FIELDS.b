* @ValidationCode : MjotMTEyMjU5NzYxOTpDcDEyNTI6MTY4MTExNTE4NjU4NTozMzNzdTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:56:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.AZ.REINV.DEPOSIT.FIELDS
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
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 10-06-2010      SUJITHA.S   ODR-2009-10-0332   INITIAL CREATION
* 24-02-2011      H GANESH      PACS00033293       Changed the vetting values of field MATURITY.INSTR
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

    CALL Table.defineId("@ID",T24_Numeric)          ;* Define Table id

*-----------------------------------------------------------------------------

    ID.F="@ID" ; ID.N="10" ;

    fieldName="CUSTOMER"
    fieldLength="35.1"
    fieldType="CUS"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="PRODUCT.CODE"
    fieldLength="10"
    fieldType="PRODCAT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="MNEMONIC"
    fieldLength="10"
    fieldType="MNE"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="CURRENCY"
    fieldLength="3.1"
    fieldType="CCY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="ACCOUNT.NAME"
    fieldLength="35"
    fieldType="SWI"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="SHORT.NAME"
    fieldLength="35"
    fieldType="SWI"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="ACCOUNT.OFFICER"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("DEPT.ACCT.OFFICER")

    fieldName="XX<JOINT.HOLDER"
    fieldLength="8"
    fieldType="CUS"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="XX>JOINT.RELCODE"
    fieldLength="8"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("RELATION")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="DEPOSIT.AMOUNT"
    fieldLength="19.1"
    fieldType="AMT"
    fieldType<2,2>='4'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="DEPOSIT.PRODUCT"
    fieldLength="35.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("AZ.PRODUCT.PARAMETER") ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="START.DATE"
    fieldLength="8.1"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="END.DATE"
    fieldLength="8.1"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field


    fieldName="DEBIT.ACCOUNT"
    fieldLength="20"
    fieldType="ACC"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")    ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="CREDIT.ACCOUNT"
    fieldLength="20"
    fieldType="ACC"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")    ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="INTEREST.RATE"
    fieldLength="16"
    fieldType="R"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    neighbour = ''
    fieldName = 'MATURITY.INSTRN'
    fieldLength = '35.1'
    fieldType = 'A'
    fieldType = '':@FM:'AUTOMATIC ROLLOVER_PAYMENT TO NOMINATED ACCOUNT'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="REINVINT.CATEG"
    fieldLength="10"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="SOURCE.FUND"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="CHARGE.CODE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("FT.CHARGE.TYPE")       ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="CHARGE.CCY"
    fieldLength="15"
    fieldType="CCY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName="CHG.LIQ.ACCT"
    fieldLength="15"
    fieldType="ACC"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")    ;* Use DEFAULT.ENRICH from SS or just field 1

    neighbour = ''
    fieldName = 'SCHEDULES'
    fieldLength = '3.1'
    fieldType = 'A'
    fieldType = '':@FM:'Y_N'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="REPAYMENT.TYPE"
    fieldLength="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="CALCULATION.BASE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="FORWARD.BACKWARD"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="TYPE.OF.SCHDLE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="FREQUENCY"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="NOMINATED.ACCOUNT"
    fieldLength="15"
    fieldType="ACC"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")    ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addOptionsField("IN.TRANSIT","YES_NO","","");

    fieldName="XX<AZ.METHOD.PAY"
    fieldLength="32"
    fieldType="A"
    fieldType = '':@FM:'CASHDEPOSIT_FROM_CHEQUE.DEPOSIT'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="XX-AZ.AMOUNT"
    fieldLength="16"
    fieldType="AMT"
    fieldType<2,2>='4'
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName="XX-AZ.SOURCE.FUND"
    fieldLength="32"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

*  fieldName="XX>AZ.DEBIT.ACC"
*  fieldLength="19"
*  fieldType="ACC"
*  neighbour=""
*  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)    ;* Add a new field
*  CALL Field.setCheckFile("ACCOUNT")  ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addField("XX>AZ.DEBIT.ACC",T24_InternalAccount,"","");

    fieldName="AZ.ACCT.NO"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)      ;* Add a new field

    fieldName = "VAL.MAT.DATE"
    fieldLength = "35"
    fieldType  = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)    ;

    fieldName = "XX<MG.ACT.NO"
    fieldLength = "35"
    fieldType = ""
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)     ;


    fieldName = "XX-FHA.POL.NO"
    fieldLength = "35"
    fieldType = "A"
    fieldType<3> = 'NOINPUT'
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;

    fieldName = "XX>FHA.CASE.NO"
    fieldLength = "35"
    fieldType = "A"
    fieldType<3> = 'NOINPUT'
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)  ;

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX.STMT.NOS'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    CALL Table.addReservedField("RESERVED.6");
    CALL Table.addReservedField("RESERVED.5");
    CALL Table.addReservedField("RESERVED.4");
    CALL Table.addReservedField("RESERVED.3");
    CALL Table.addReservedField("RESERVED.2");
    CALL Table.addReservedField("RESERVED.1");

*  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*  CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
