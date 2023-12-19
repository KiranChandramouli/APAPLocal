* @ValidationCode : MjotNzczMjgzOTg2OkNwMTI1MjoxNjg0ODQyMTMyNjAxOklUU1M6LTE6LTE6LTEyOjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STOCK.QTY.COUNT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.STOCK.QTY.COUNT.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.STOCK.QTY.COUNT
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                        Description
*   ------         ------               -------------                    -------------
* 8 MAR 2011    SWAMINATHAN.S.R       ODR-2010-03-0400                  Initial Creation
*18-04-2023       Conversion Tool      R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T            R22 Manual Code Conversion         No Changes
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '65'    ; ID.T = 'A'

*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'AGENCY'  ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('COMPANY')
    fieldName = 'CARD.TYPE'  ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CARD.TYPE')
    fieldName = 'XX<DATE'  ; fieldLength = '10'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-QTY.RECD' ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-DAMAGE'  ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-LOST'  ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-ISSUED'  ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-STOCK.QTY'   ; fieldLength = '20'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-RETURNED'   ; fieldLength = '20'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX>DESTROYED'   ; fieldLength = '20'   ; fieldType = ''  ;  GOSUB ADD.FIELDS

    V = Table.currentFieldPosition

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
RETURN
*----------------------------------------------------------------------------
END
