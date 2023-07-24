* @ValidationCode : MjotOTQ2OTM5MDAxOkNwMTI1MjoxNjgxMTA5ODQzMDM4OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
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
SUBROUTINE REDO.THIRDPRTY.PAYMENT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.THIRDPRTY.PAYMENT.FIELDS
*
* @author GANESHR@temenos.com
* @LIVE template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  Date          who                  Reference       Description
*  11 JAN 2010   GANESH                               INITIAL CREATION
*  12 JUL 2013   VIGNESH KUMAAR M R   PACS00307024    SELECTION TO BE BASED ON THE COMPANY
*  30 JUL 2013   VIGNESH KUMAAR M R   PACS00307023    THIRDPARTY PAYMENT ENQ DROPDOWN
* 10.04.2023     Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023     Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    ID.F="@ID"
    ID.N="12"
    ID.T ="A"

    fieldName="BRANCH"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('REDO.THIRDPRTY.PARAMETER')       ;* Fix for PACS00307023 [THIRDPARTY PAYMENT ENQ DROPDOWN]

    fieldName="TELLER.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="TELLER.NAME"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="COMP.NAME"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="BILL.COND"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="BILL.TYPE"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="BILL.NUMBER"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="METHOD.OF.PAY"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="AMOUNT"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="CHEQUE.NUMBER"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

* Fix for PACS00307024 [SELECTION TO BE BASED ON THE COMPANY]

    fieldName = "PAY.COMPANY"
    fieldLength = "9"
    fieldType = "A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('COMPANY')    ;* Fix for PACS00307023 [THIRDPARTY PAYMENT ENQ DROPDOWN]

* End of Fix

RETURN

*-----------------------------------------------------------------------------
END
