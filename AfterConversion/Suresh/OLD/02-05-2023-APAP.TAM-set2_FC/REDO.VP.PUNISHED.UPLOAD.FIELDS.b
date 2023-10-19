* @ValidationCode : MjotMTY1ODc5NjU1ODpDcDEyNTI6MTY4MTg5MzEwMzE4NTpzYW1hcjotMTotMTowOjA6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 14:01:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.PUNISHED.UPLOAD.FIELDS

******************************************************************************
* Company Name    : T24
* Developed By    : Mauricio Sthandier - msthandier@temenos.com
*
* Subroutine Type : T
* Attached to     : REDO.VP.PUNISHED.UPLOAD
* Attached as     : .FIELDS routine
* Primary Purpose : Campos de REDO.VP.PUNISHED.UPLOAD
* Date:           : Jan 2015
*
* Incoming:
* ---------
* N/A
*
* Outgoing:
* ---------
* N/A
*
* Error Variables:
* ----------------
* N/A
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* MSR201405
*-----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE



    ID.F    = '@ID'
    ID.N    = '12'
    ID.T    = 'A'

    fieldName = 'CARD.NUMBER'
    fieldLength = '16'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'CLIENT.NAME'
    fieldLength = '20'
    neighbour = ''
    fieldType = 'CUS'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("CUSTOMER")

    fieldName = 'EFFECTIVE.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'PROCESSING.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'MATURITY.DATE'
    fieldLength = '10'
    neighbour = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'TOTAL.AMOUNT'
    fieldLength = '19'
    neighbour = ''
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX<ACTIVITY.STATUS'
    fieldLength = '1'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX>ACTIVITY.MESSAGE'
    fieldLength = '256'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'OVERALL.STATUS'
    fieldLength = '1'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

RETURN

END
