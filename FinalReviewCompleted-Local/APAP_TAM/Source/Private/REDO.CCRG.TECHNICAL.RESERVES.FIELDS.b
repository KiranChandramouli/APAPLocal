* @ValidationCode : MjotODg2ODk5MDg4OkNwMTI1MjoxNjg0ODQxOTQxOTc0OklUU1M6LTE6LTE6LTEyOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:09:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.TECHNICAL.RESERVES.FIELDS
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
* 14/March/2010 - EN_10003543
*                 New Template changes
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION        NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CURRENCY
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
    dataType      = ''
    dataType<2>   = 16.1
    dataType<3>   = ''
    dataType<3,2> = 'SYSTEM'
    CALL Table.defineId("@ID", dataType)  ;* Define Table id
*-----------------------------------------------------------------------------
    nArrayItem = "4"
    tArrayItem = "CCY"
    CALL Table.addFieldDefinition("LOCAL.CCY", nArrayItem, tArrayItem,neighbour)
    CHECKFILE(Table.currentFieldPosition) ="CURRENCY":@FM:EB.CUR.CCY.NAME:@FM:"L"
    T(Table.currentFieldPosition)<3> = "NOINPUT"
*
    nArrayItem = "19.1"
    tArrayItem = "LAMT" : @FM : "" : @VM : LCCY
    CALL Table.addFieldDefinition("TECH.RES.AMOUNT", nArrayItem, tArrayItem,neighbour)
*
    CALL Table.addField("EFFECTIVE.DATE", T24_Date, Field_Mandatory, '')          ;* Add a new fields
*
    CALL Table.addReservedField("RESERVED.1")       ;* Add a new Reserved fields
    CALL Table.addReservedField("RESERVED.2")       ;* Add a new Reserved fields
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
