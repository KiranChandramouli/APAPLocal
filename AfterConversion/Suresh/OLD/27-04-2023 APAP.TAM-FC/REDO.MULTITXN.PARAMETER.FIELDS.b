* @ValidationCode : MjoyMzIxMTA4MDU6Q3AxMjUyOjE2ODEyMzkwOTE1MzA6SVRTUzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:31
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
SUBROUTINE REDO.MULTITXN.PARAMETER.FIELDS
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
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("SYSTEM", T24_String)       ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX<ACTUAL.CATEG", "6", "A", "")      ;* Add a new fields
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1
    CALL Table.addFieldDefinition("XX-NEW.CATEG", "6","A", "")          ;* Add a new fields
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1
    CALL Table.addFieldDefinition("XX>SUSP.CATEG", 6, "A", "")          ;* Add a new fields
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1



    CALL Table.addFieldDefinition("CATEG.CASH", "6", "A", "") ;* Add a new fields
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("CATEG.CHECK", "6","A", "") ;* Add a new fields
    CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("CHECK.ACCOUNT", "13", "A", "")       ;* Add a new fields
    CALL Table.addFieldDefinition("CHECK.TRANSACT", "3","A", "")        ;* Add a new fields
    CALL Field.setCheckFile("TRANSACTION")          ;* Use DEFAULT.ENRICH from SS or just field 1


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
