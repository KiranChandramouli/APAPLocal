* @ValidationCode : MjoyNDEyNTE0NjI6Q3AxMjUyOjE2ODE4ODQ3NzcxNTQ6MzMzc3U6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:42:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISION.PLUS.TXN.DET.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions for the application REDO.VISION.PLUS.TXN.DET
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour   = ''
    fieldName   = 'RECORD.TYPE'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.STATUS'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'BATCH.NBR'
    fieldLength = '5'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'SEQUENCE.NBR'
    fieldLength = '3'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'MON.RECORD.TYPE'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CARDHLD.NBR'
    fieldLength = '16'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.CODE'
    fieldLength = '4'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.AMOUNT'
    fieldLength = '20.2'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.DATE'
    fieldLength = '6'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.AUTH'
    fieldLength = '6'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.REF'
    fieldLength = '23'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.CASHBACK'
    fieldLength = '19'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.SOURCE.ID'
    fieldLength = '3'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.DESC'
    fieldLength = '40'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.VISA.MAIL'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.MERCH.CATEG'
    fieldLength = '5'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.POS.CAP'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.POS.ENT'
    fieldLength = '2'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.CARDHLDR.ID'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.AUTH.SOURCE'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.ATM.ACCT'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'ACT.TERM.ID'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'NUM.PLAN'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.ACCT.TERM'
    fieldLength = '1'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'NUM.SEQ.PLAN'
    fieldLength = '2'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    V = Table.currentFieldPosition

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
