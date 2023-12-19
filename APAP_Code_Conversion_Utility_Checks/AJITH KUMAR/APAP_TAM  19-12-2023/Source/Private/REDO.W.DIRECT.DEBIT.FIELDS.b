* @ValidationCode : MjoxNTkyNjE3MTU4OkNwMTI1MjoxNjgxMTkzOTM0Mzc3OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:54
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
SUBROUTINE REDO.W.DIRECT.DEBIT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author pgarzongavilanes@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/03/11 - First release
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '25'
    ID.T = "A"   ;
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX.ARR.ID", "35", "A", "") ;* Add a new fields
    CALL Table.addFieldDefinition("XX.FT.ID", "55", "A", "")

    CALL Table.addFieldDefinition("XX<CREDIT.AC.ID", "35", "A", "")

    CALL Table.addFieldDefinition("XX-DEBIT.AC.ID", "35", "A", "")

    CALL Table.addFieldDefinition("XX-XX<BILL.AMT.ARR.ID", "35", "A", "")
    CALL Table.addFieldDefinition("XX-XX>BILL.ID", "100", "A", "")
    CALL Table.addFieldDefinition("XX>XX.REASON", "100", "A", "")
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
