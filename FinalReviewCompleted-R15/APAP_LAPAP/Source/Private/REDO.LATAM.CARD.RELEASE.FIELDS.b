* @ValidationCode : MjoxNzc2NDU2Mzc1OkNwMTI1MjoxNjg0MjIyODMyNTY2OklUU1M6LTE6LTE6LTc6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.LATAM.CARD.RELEASE.FIELDS
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
* CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id

    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '14'    ; ID.T = 'A'

*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'XX.CARD.NUMBER'
    fieldLength = '19.1'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    CALL Table.addReservedField('RESERVED.1')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.7')

    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.10')

*-----------------------------------------------------------------------------

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
