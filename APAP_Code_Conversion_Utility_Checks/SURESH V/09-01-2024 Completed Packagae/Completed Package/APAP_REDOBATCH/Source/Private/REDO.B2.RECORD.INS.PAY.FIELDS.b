* @ValidationCode : MjotODk0MjQ1NDQ5OkNwMTI1MjoxNjg0ODU0NDAzNDY3OklUU1M6LTE6LTE6LTk6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B2.RECORD.INS.PAY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.B2.FT.PARAMETERS.FIELDS *
* @author ejijon@temenos.com
* @stereotype fields template
* @uses Table
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'

*------------------------------------------------------------------------------
*
*

    fieldName = 'XX<DATES'
    fieldLength = '20'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX.XX>FT.IDS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    CALL Table.addReservedField("RESERVED.1")


*
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
