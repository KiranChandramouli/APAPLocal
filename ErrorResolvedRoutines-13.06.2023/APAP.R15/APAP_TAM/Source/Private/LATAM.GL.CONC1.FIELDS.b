* @ValidationCode : MjoxMjI3NzAwODcwOkNwMTI1MjoxNjgwNjEwNzQ4MDI0OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:49:08
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
SUBROUTINE LATAM.GL.CONC1.FIELDS
*-----------------------------------------------------------------------------
*******************************************************************************************************************
*Company   Name    : BCDX Bank
*Developed By      : Temenos Application Management (Mohamed Raffikulla [raffiq@temenos.com])
*Program   Name    : Template
*------------------------------------------------------------------------------------------------------------------
*Description : This template will have excluded ID of Journal entries
*
*

*Linked With       : n/a
*In  Parameter     : n/a
*Out Parameter     : n/a
*------------------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*23/07/2009 - ODR-2009-12-0080
*             Development For Journal Pack
*************************************************************************************************
*
* Date             Who              Reference      Description
* 04.04.2023    Conversion Tool      R22            Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22            Manual Conversion   - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

**********************@ID FIELD*****************
    ID.F='ID'
    ID.N='70'
    ID.T='ANY'

*******************DESCRIPTION FIELD *****************

    fieldName = 'ENTRY.KEY'
    fieldLength = '70'
    fieldType = 'ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;



*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
