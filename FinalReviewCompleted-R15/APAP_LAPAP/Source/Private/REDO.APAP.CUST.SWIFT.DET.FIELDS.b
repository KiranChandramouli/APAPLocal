* @ValidationCode : MjotNTYzMjk2NTM1OkNwMTI1MjoxNjgyMzMxNTY0NzEyOklUU1M6LTE6LTE6LTM6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.CUST.SWIFT.DET.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CUST.SWIFT.DET.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.AA.CP.OVERPAYMENT
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*    27/05/2015    Ashokkumar.V.P                                    Initial Release
*    21.04.2023    Conversion Tool             R22                   Auto Conversion     - $INCLUDE T24.BP TO $INSERT
*    21.04.2023    Shanmugapriya M             R22                   Manual Conversion   - No changes
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON               ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE               ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_DataTypes            ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = "A"
*------------------------------------------------------------------------------

    fieldName='CUSTOMER.ID'
    fieldLength='35'
    fieldType='CUS'; neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CUSTOMER")

    fieldName='DESCRIPTION'
    fieldLength='100'
    fieldType='TEXT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.setAuditPosition         ;* Poputale audit information
RETURN
END
