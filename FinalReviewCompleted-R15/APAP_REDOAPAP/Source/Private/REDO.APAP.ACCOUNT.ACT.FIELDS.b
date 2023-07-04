* @ValidationCode : MjoxODE2NzAzOTE5OkNwMTI1MjoxNjg0ODM2MDMyNDc2OklUU1M6LTE6LTE6LTI1OjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -25
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.ACCOUNT.ACT.FIELDS
*-------------------------------------------------------------------------
*********************************************************************************************************
* Company   Name    : APAP Bank
* Developed By      : Temenos Application Management
* Program   Name    : REDO.APAP.ACCOUNT.ACT.FIELDS
*--------------------------------------------------------------------------------------------------------
* Description       : REDO.APAP.ACCOUNT.ACT is an L type template; this template is used to record
*                    the details of effective discount rate and amount for the sec trades
*-------------------------------------------------------------------------
* Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20-Jun-2013      Arundev KR            PACS00293038            Initial creation
* 12-Feb-2014     V.P.Ashokkumar         PACS00309822            Added new field to capture curr no
* Date                  who                   Reference              
* 04-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table

*-------------------------------------------------------------------------

    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '8'    ; ID.T = 'A'

*-----------------------------------------------------------------------------

    neighbour = ''

    fieldName = 'XX-ACCT.NO'
    fieldLength = '25'
    fieldType = 'ANY'
    GOSUB ADD.FIELDS

    fieldName = "ACCT.DATE.CURR" ;  fieldLength = "30" ; fieldType = "ANY"
    GOSUB ADD.FIELDS

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
