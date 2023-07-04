* @ValidationCode : MjozNzU0MTkxMTM6Q3AxMjUyOjE2ODQ4MzYwMzUwMDQ6SVRTUzotMTotMTotNjoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CLEAR.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.APAP.CLEAR.PARAM.FIELDS.
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-09-0148
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 18/11/10 - 3 fields has been amended TT.FT.TRAN.TYPE,IN.TRANSIT.RATE,CAT.OWD.RETURN
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>


*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.T = '':@FM:'SYSTEM'
    ID.N = '6'

    neighbour = ''
    fieldName = 'INWARD.DR.CODE'   ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'INWARD.CR.CODE'   ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'COMM.DR.CODE'     ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'COMM.CR.CODE'     ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'TAX.DR.CODE'      ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'TAX.CR.CODE'      ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CAT.ACH.ACCT'  ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'CAT.OWD.RETURN'  ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INW.SETTLEMENT'; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INW.RETURN'    ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INW.REFERRAL'  ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'OUT.SETTLEMENT'; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'OUT.RETURN'    ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TAX.CLEARING'  ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLEARING.SUSP' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLEARING.COMM'    ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TAX.PERCENT'      ; fieldLength = '5' ; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CUTOFF'           ; fieldLength = '5' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FUND.RELES.TIME'  ; fieldLength = '5' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<FORWARD.DAYS'  ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-BANK.CATEGORY' ; fieldLength = '10' ;  fieldType<2> = "APAP_OTHERS"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-OPERAND'       ; fieldLength = '4' ; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>AMOUNT'        ; fieldLength = '15'; fieldType = 'AMT' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<CUSTOMER.TYPE' ; fieldLength = '15'; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>FT.REF.CHG'    ; fieldLength = '15'; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.TT.FT.TRAN.TYPE'  ; fieldLength = '20'; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'IN.TRANSIT.RATE'  ; fieldLength = '5'; fieldType = 'A';
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'ADJUST.CR.CODE'
    fieldLength = '11'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    neighbour = ''
    fieldName = 'ADJUST.DR.CODE'
    fieldLength = '11'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CAPITALISE.ACCT' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CAPITAL.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CAPITAL.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'AA.WASHTHROUGH' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<CURRENCY' ; fieldLength = '3' ; fieldType = 'CCY' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName = 'XX-NO.OF.RESTR.DAYS' ; fieldLength = '5' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>POSTING.RESTR' ; fieldLength = '2' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("POSTING.RESTRICT")

    fieldName = 'CHEQUE.RETAIN' ; fieldLength = '3' ; fieldType = 'PERIOD' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MAX.RET.CHEQUES' ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'LOAN.CLOSE.DAYS' ; fieldLength = '3' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INTEREST.BASIS' ; fieldLength = '2' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("INTEREST.BASIS")


    fieldName = 'TRANCAP.ACCT' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TRANCAP.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'TRANCAP.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'UNIV.CLEAR.ACCT' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'CLEARING.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CLEARING.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CAT.ACH.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")

    fieldName = 'CAT.ACH.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("TRANSACTION")


    fieldName = 'XX.CATEG.APERTA' ; fieldLength = '11' ; fieldType = '' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CATEGORY")

*    CALL Table.addReservedField('RESERVED.7')
*    CALL Table.addReservedField('RESERVED.6')

    fieldName = 'AC.OPEN.CODE' ; fieldLength = '10' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'AC.CLOSE.CODE' ; fieldLength = '10' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'REV.VERSION.NAME'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('VERSION')

    fieldName = 'UNIV.CLR.USAC' ; fieldLength = '20' ; fieldType = 'A' ;
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------

RETURN
END
