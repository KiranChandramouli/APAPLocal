* @ValidationCode : MjoxMzg3ODE2OTA4OkNwMTI1MjoxNjg0ODQyMTMwMDM1OklUU1M6LTE6LTE6LTM6MTp0cnVlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RISK.GROUP.FIELDS

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.RISK.GROUP.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.RISK.GROUP
*LINKED WITH    :REDO.RISK.GROUP
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes




    ID.F='RISK.GRP.CODE'
    ID.N='0010.1'
    ID.T='ANY'

*-------------------------------------------------------------------------
    fieldName="XX.RISK.GRP.DESC"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.GRP.SHORT.DESC"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.setAuditPosition
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
