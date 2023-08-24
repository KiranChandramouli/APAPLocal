* @ValidationCode : MjoxMTk3MzYxMTIxOkNwMTI1MjoxNjgwNjAyNDgwNTk3OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:31:20
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
SUBROUTINE INTERFACE.CONFIG.PRT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine INTRF.MESSAGE.FIELDS
*
* @author:
*stereotype fields template
* @uses Table
* @public Table Creation
* @package
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*            New Template changes
*** 04-04-2023 R22 Auto Conversion – FM TO @FM, VM to @VM, SM to @SM
** 04-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("INTRF.MSG.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX<INT.FLD.NAME","200","ANY","")
    CALL Table.addFieldDefinition("XX-INT.FLD.VAL","200","ANY","")
    fieldtype = @FM:"Y_N"
    CALL Table.addFieldDefinition("XX>INT.ENCRY","10",fieldtype,"")
*    fieldtype = FM:"#"

    CALL Table.addFieldDefinition("INT.MAIN.ENC","10","A","")
*    CALL Field.setDefault("#")
* fieldtype = FM:"|"
    CALL Table.addFieldDefinition("INT.SUB.ENC","10","A","")
*   CALL Field.setDefault("|")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------

END
