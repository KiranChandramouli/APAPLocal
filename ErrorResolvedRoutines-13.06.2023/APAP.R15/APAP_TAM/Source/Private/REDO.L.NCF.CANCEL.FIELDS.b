* @ValidationCode : MjotMTYzNTk5MDkwMzpDcDEyNTI6MTY4MTIzOTA5MDg5NDpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:30
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
SUBROUTINE REDO.L.NCF.CANCEL.FIELDS
*DESCRIPTION:
*------------
*This routine defines fields for the table REDO.L.NCF.STATUS

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-FEB-2010       Ganesh.R       ODR-2009-10-0321    Initial Creation.
* 12.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
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
    ID.F="@ID"
    ID.N="8.1"
    ID.T=""
*-----------------------------------------------------------------------------
    fieldName="TRANSACTION.ID"
    fieldLength="16.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CUSTOMER.ID"
    fieldLength="10.1"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CANCEL.TYPE"
    fieldLength="32.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.L.NCF.CANCELLATION.TYPE')

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
