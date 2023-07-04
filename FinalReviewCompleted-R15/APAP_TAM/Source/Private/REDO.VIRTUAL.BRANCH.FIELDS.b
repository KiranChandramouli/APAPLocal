* @ValidationCode : MjotNDAyNzM0MDUxOkNwMTI1MjoxNjgxMTg5OTk2MDk3OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:43:16
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
SUBROUTINE REDO.VIRTUAL.BRANCH.FIELDS

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.BRAN.EDU.DETS.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.BRAN.EDU.DETS
*LINKED WITH    :REDO.BRAN.EDU.DETS
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*MODIFICATION DETAILS:
*     03NOV09 ODR-2009-10-0526
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    ID.F=''
    ID.N='4'
    ID.T=''

*-------------------------------------------------------------------------
    fieldName="XX.LL.DESCRIPTION"
    fieldLength=35.1
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.LL.SHORT.DESC"
    fieldLength=20.1
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Table.setAuditPosition

RETURN
END
