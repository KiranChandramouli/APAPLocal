* @ValidationCode : MjoxNDc2NTM1MzEyOkNwMTI1MjoxNjg0ODQxODkxNjY1OklUU1M6LTE6LTE6LTI1OjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -25
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.RISK.LIMIT.PARAM.FIELDS
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 14/March/2011 - EN_10003543
*                 New Template changes
*REM Just for compile
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
    $INSERT I_F.PGM.FILE
    $INSERT I_F.CURRENCY
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("RISK.LIMIT.ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("DESCRIPTION", T24_String, Field_NoInput, '')   ;* Add a new fields

    args = ''
    args = Field_Mandatory:",":Field_NoInput
    CALL Table.addField("LOCAL.CCY", T24_Currency, args, '')  ;* Add a new fields
    CHECKFILE(Table.currentFieldPosition) ="CURRENCY":@FM:EB.CUR.CCY.NAME:@FM:"L"
    T(Table.currentFieldPosition)<3> = "NOINPUT"

    CALL Table.addFieldDefinition("PERCENTAGE", "6", 'R', '') ;* Add a new fields

    args = ''
    args = Field_NoInput
    CALL Table.addAmountField("MAX.AMOUNT", "LOCAL.CCY", args, '')      ;* Add a new fields

    args = ''
*    CALL Table.addField("XX<APPLICATION", "40..C" , args, '')         ;* Add a new
    CALL Table.addFieldDefinition("XX<APPLICATION", "40..", 'PG' : @FM : 'AHULTMSW', '')     ;* Add a new fields
    CALL Field.setDefault("CUSTOMER")
    CHECKFILE(Table.currentFieldPosition) ="PGM.FILE":@FM:EB.PGM.SCREEN.TITLE:@FM:"L"
*

    CALL Table.addFieldDefinition('XX-XX<FIELD.NO', 18, 'A', '')        ;* Add a new fields
*
    fieldType = '':@FM:'EQ_NE_RG_NR'
    CALL Table.addFieldDefinition('XX-XX-OPERATOR', 3, fieldType, '')   ;* Add a new fields
*
    CALL Table.addFieldDefinition('XX-XX-MIN.VALUE', 40, 'A', '')       ;* Add a new fields
*
    CALL Table.addFieldDefinition('XX-XX-MAX.VALUE', 40, 'A', '')       ;* Add a new fields
*
    fieldType = '':@FM:'OR_AND'
    CALL Table.addFieldDefinition('XX-XX-BOOL.OPER', 3, fieldType, '')  ;* Add a new fields
*
    CALL Table.addOptionsField("FSHOW.TDIS","YES_NO",'', '')

    CALL Table.addReservedField("XX>XX>RESERVED.1") ;* Add a new Reserved fields

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
