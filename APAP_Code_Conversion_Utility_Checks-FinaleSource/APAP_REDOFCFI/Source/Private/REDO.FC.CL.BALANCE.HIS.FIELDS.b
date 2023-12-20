* @ValidationCode : MjotNTQ4MTgyNjIyOkNwMTI1MjoxNjgwNjAzMjM2MTYyOklUU1M6LTE6LTE6LTEzOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:43:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.CL.BALANCE.HIS.FIELDS
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
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.PGM.FILE
    $INSERT I_F.VERSION
    $INSERT I_F.AA.ARRANGEMENT
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.CHECKFILE = "AA.ARRANGEMENT" : @FM : @ID

*-----------------------------------------------------------------------------
    CALL Table.addField("AA.AMOUNT", T24_Numeric, "", "")     ;* Add a new fields
    CALL Table.addField("AA.BALANCE", T24_Numeric, "", "")    ;* Add a new fields

    CALL Table.addFieldDefinition("XX<COLLATERAL.RIGHT", 35, "A", "")   ;* Add a new fields
    CALL Field.setCheckFile("COLLATERAL.RIGHT")     ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("XX-COLLATERAL.ID", 35, "A", "")      ;* Add a new fields
    CALL Field.setCheckFile("COLLATERAL") ;* Use DEFAULT.ENRICH from SS or just field 1


    CALL Table.addField("XX>MG.ORIGINAL", T24_Numeric, "", "")          ;* Add a new fields














*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
