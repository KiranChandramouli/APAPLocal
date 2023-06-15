* @ValidationCode : MjoyNDg2OTUzMTI6Q3AxMjUyOjE2ODQ4NDIwOTA1ODk6SVRTUzotMTotMTotNToxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CLOSE.ACCT.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 26/07/2010 - C.22 New Template Creation
* 28/07/2011 - PACS00089082 - field property changed for DIR.PATH
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*-----------------------------------------------------------------------------

    fieldName="LIQ.ACCOUNT"
    fieldLength="35.3"          ;* C.21
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CUST"
    fieldLength="30"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="PRODUCT"
    fieldLength="40"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
RETURN

END
