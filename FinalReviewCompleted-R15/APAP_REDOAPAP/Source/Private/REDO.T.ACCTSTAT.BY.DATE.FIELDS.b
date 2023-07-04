* @ValidationCode : MjotMTEwODA5NzA0ODpDcDEyNTI6MTY4NTAxNTIzMjU2NDp2aWN0bzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 May 2023 17:17:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.T.ACCTSTAT.BY.DATE.FIELDS
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
* 19/10/07 - JAYASURYA H
*  DATE            NAME                  REFERENCE                     DESCRIPTION
* 24 NOV  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_Date) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = '8'
    ID.T = 'D'
    CALL Table.addFieldDefinition("XX.ACCOUNT","19","N","") ;* Add a new field


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
