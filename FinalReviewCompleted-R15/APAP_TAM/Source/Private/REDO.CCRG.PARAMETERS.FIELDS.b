* @ValidationCode : MjoxNTg0Nzk2NDg1OkNwMTI1MjoxNjg0ODQxODg5NDI5OklUU1M6LTE6LTE6LTE0OjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.PARAMETERS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.PARAMETERS
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/04/2011 - APAP : B5
*              First Version
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
    $INSERT I_F.EB.API
    $INSERT I_F.EB.PRODUCT


*** </region>
*-----------------------------------------------------------------------------
    dataType      = ''
    dataType<2>   = 16.1
    dataType<3>   = ''
    dataType<3,2> = 'SYSTEM'
    CALL Table.defineId("@ID", dataType)  ;* Define Table id
*-----------------------------------------------------------------------------
    fieldLength = "05.1.C"
    fieldType<4> = "R##:##"
    fieldType<5> = "C"
    CALL Table.addFieldDefinition("EFFECTIVE.TIME", fieldLength, fieldType, '')

    args = ''
    args = Field_Mandatory
    CALL Table.addOptionsField("XX<PRODUCT","AA_FX_MM_SC_LI",args,"")
    CHECKFILE(Table.currentFieldPosition) = "EB.PRODUCT" : @FM : EB.PRD.DESCRIPTION : @FM :"L.A"

    args = ''
    args = 'HOOK': @FM :Field_Mandatory
    CALL Table.addFieldDefinition("XX-EVALUATOR.RTN", '40',args , '')
    CHECKFILE(Table.currentFieldPosition) = "EB.API" : @FM : EB.API.DESCRIPTION : @FM :"L.A"

    args = ''
    args = 'HOOK': @FM :Field_Mandatory
    CALL Table.addFieldDefinition("XX-GET.BAL.RTN", '40', args, '')
    CHECKFILE(Table.currentFieldPosition) = "EB.API" : @FM : EB.API.DESCRIPTION : @FM :"L.A"

    CALL Table.addReservedField("XX>RESERVED.1")    ;* Add a new Reserved fields
    CALL Table.addReservedField("RESERVED.2")       ;* Add a new Reserved fields
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
