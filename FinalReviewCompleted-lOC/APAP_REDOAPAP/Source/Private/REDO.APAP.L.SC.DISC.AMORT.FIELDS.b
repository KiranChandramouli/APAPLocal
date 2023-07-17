* @ValidationCode : MjotMTk3Njk4ODU3OkNwMTI1MjoxNjgwNjc5ODg5NzU4OklUU1M6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:01:29
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.L.SC.DISC.AMORT.FIELDS
*-------------------------------------------------------------------------
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.L.SC.DISC.AMORT.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.L.SC.DISC.AMORT is an L type template; this template is used to record
*                    the details of effective discount rate and amount for the sec trades
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 18-Feb-2013      Arundev KR           CR008 RTC-553577       Initial creation
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*-------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'NOMINAL'            ; fieldLength = '19'   ; fieldType = 'AMT'   ;  GOSUB ADD.FIELDS
    fieldName = 'LIN.ACCR.AMT'       ; fieldLength = '19'   ; fieldType = 'AMT'   ;  GOSUB ADD.FIELDS
    fieldName = 'DAYS.TO.MAT'        ; fieldLength = '10'   ; fieldType = ''      ;  GOSUB ADD.FIELDS
    fieldName = 'XX<DISC.ACC.DATE'   ; fieldLength = '8'    ; fieldType = 'D'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EFF.DISC.RATE'   ; fieldLength = '16'   ; fieldType = 'R'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX>EFF.DISC.AMT'    ; fieldLength = '19'   ; fieldType = 'AMT'   ;  GOSUB ADD.FIELDS
    fieldName = 'EFF.DISC.TODATE'    ; fieldLength = '19'   ; fieldType = 'AMT'   ;  GOSUB ADD.FIELDS
    fieldName = 'EFF.ADJ.DISC.TOT'   ; fieldLength = '19'   ; fieldType = 'AMT'   ;  GOSUB ADD.FIELDS

    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    V = Table.currentFieldPosition

RETURN

*-------------------------------------------------------------------------
ADD.FIELDS:
*-------------------------------------------------------------------------

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN

*-----------------------------------------------------------------------------
END
