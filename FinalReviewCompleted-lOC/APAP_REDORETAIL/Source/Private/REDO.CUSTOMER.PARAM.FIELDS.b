* @ValidationCode : MjotNjI2NzYyMTQ0OkNwMTI1MjoxNjgxODI5MDkxMDU3OklUU1M6LTE6LTE6LTM6MTp0cnVlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:51
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
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CUSTOMER.PARAM.FIELDS

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.CUSTOMER.PARAM.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.CUSTOMER.PARAM.FIELDS
*LINKED WITH    :REDO.CUSTOMER.PARAM.FIELDS
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*-------------------------------------------------------------------------
*ODR-2010-08-0031   Prabhu N  initial draft
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


    ID.F='CUSTOMER'
    ID.T=''

*-------------------------------------------------------------------------
    fieldName="CUSTOMER.NAME"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="AC.ENTRY.PARAM"
    fieldLength='35.1'
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.setAuditPosition
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
