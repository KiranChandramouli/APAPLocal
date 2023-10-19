* @ValidationCode : MjotMTEzOTYxNzMwMjpDcDEyNTI6MTY5NjU5MzU4OTA4MjozMzNzdTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2023 17:29:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.PREVALANCE.STATUS.FIELDS
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
*  DATE            NAME                  REFERENCE                     DESCRIPTION
* 24 NOV  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*06/10/2023      Conversion tool            R22 Auto Conversion             Nochange
*06/10/2023      Suresh                     R22 Manual Conversion           Nochange
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '7'
    ID.T<1> = ""
    ID.T<2> = "SYSTEM"
    Y.FINAL.TABLE=''
    table = 'L.AC.STATUS1'
    CALL EB.LOOKUP.LIST(table)
    table1 = 'L.AC.STATUS2'
    CALL EB.LOOKUP.LIST(table1)

    Y.FINAL.TABLE<2> = table<2>:'_':table1<2>
    Y.FINAL.TABLE<11>=  table<11>:'_':table1<11>

    fieldName="XX<ACCT.TYPE"
    fieldLength="65"
    neighbour=''
    fieldType='A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-XX.STATUS"
    fieldLength="65"
    neighbour=''
    fieldType=Y.FINAL.TABLE
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-BAL.RECLASS"
    fieldLength="65"
    neighbour=''
    fieldType='A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-INT.RECLASS"
    fieldLength="65"
    neighbour=''
    fieldType='A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX>PREVALANT.STATUS"
    fieldLength="3"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.STATUS')


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
