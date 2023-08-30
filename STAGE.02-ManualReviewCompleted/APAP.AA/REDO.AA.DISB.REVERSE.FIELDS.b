* @ValidationCode : MjotMTkzMjYwOTg3OkNwMTI1MjoxNjgwMTc3OTQ3MTE1OklUU1M6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 30 Mar 2023 17:35:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.AA.DISB.REVERSE.FIELDS
*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.DISB.CHAIN
* Attached as     :
* Primary Purpose : Define the fields to table REDO.DISB.CHAIN
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 10 Agosto 2011
*
* Date            : 01-07-2017   - Edwin Charles D - PACS00236823
* Date                     who                   Reference
* 29-03-2023            Conversion Tool      R22 AUTO CONVERSTION - No Change
* 29-03-2023            ANIL KUMAR B         R22 MANUAL CONVERSTION - NO CHANGES
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*************************************************************************

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'XX<DESB.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-XX<FT.TEMP.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX>XX>FT.TXN.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

RETURN
END
