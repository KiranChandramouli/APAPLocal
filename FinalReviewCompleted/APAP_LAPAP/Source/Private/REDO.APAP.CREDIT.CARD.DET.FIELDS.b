* @ValidationCode : Mjo0NzIzMDU1Mjk6Q3AxMjUyOjE2ODIzMzE1NjQ2NDQ6SVRTUzotMTotMTotMjoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.CREDIT.CARD.DET.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Program   Name    : REDO.APAP.CREDIT.CARD.DET.FIELDS
*-----------------------------------------------------------------------------
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*    15/01/2019    Ashokkumar.V.P                                 Initial Release
*    20.04.2023    Conversion Tool            R22                 Auto Conversion     - $INCLUDE T24.BP TO $INSERT
*    20.04.2023    Shanmugapriya M            R22                 Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON                         ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE                         ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_DataTypes                      ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '16.1'
    ID.T = "A"
*------------------------------------------------------------------------------

    fieldName='CARD.LOGO'
    fieldLength='3'
    fieldType='A'; neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CARD.ORG'
    fieldLength='3'
    fieldType='A'; neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CARD.DESCRIPTION'
    fieldLength='35'
    fieldType='ANY'; neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.setAuditPosition         ;* Poputale audit information
RETURN
END
