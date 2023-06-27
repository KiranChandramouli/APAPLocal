* @ValidationCode : MjotMTAwODAwNjU4NTpDcDEyNTI6MTY4MTIzOTA5MTQyMjpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE REDO.MAX.PRESTAR.VS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.MAXIMO.PRESTAR.VS.FIELDS
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
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("PRODUCT.GROUP", 35, "A", "")
    CALL Field.setCheckFile("AA.PRODUCT.GROUP")
    CALL Table.addOptionsField("VEH.TYPE","NUEVO_USADO","","")
    CALL Table.addFieldDefinition("VEH.USE.DESC", 35, "A", "")
    CALL Table.addFieldDefinition("VEH.USE.FROM", 3, "A", "")
    CALL Table.addFieldDefinition("VEH.USE.TO", 3, "A", "")
    CALL Table.addFieldDefinition("PERC.MAX.AMT.LOAN", 4, "", "")

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
