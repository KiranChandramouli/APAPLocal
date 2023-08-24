* @ValidationCode : MjoxMTQzNzYxMjIwOkNwMTI1MjoxNjgxMTA5ODQyOTk0OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:22
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
SUBROUTINE REDO.TFS.TRANSACTION.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TFS.TRANSACTION.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.TFS.TRANSACTION.DETAILS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*     Date              Who                 Reference                 Description
*    ------            ------              -------------             -------------
* 12th JULY 2010    Shiva Prasad Y      ODR-2009-10-0318 B.126      Initial Creation
* 10.04.2023       Conversion Tool       R22                        Auto Conversion     - FM TO @FM
* 10.04.2023       Shanmugapriya M       R22                        Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '10'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'DESCRIPTION'           ; fieldLength = '50'     ; fieldType = 'A'                 ;  GOSUB ADD.FIELDS
    fieldName = 'XX<TFS.TRANSACTION'    ; fieldLength = '35.1'   ; fieldType = 'A'                     ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TFS.TRANSACTION')
    fieldName = 'XX-TFS.TXN.TYPE'       ; fieldLength = '10'     ; fieldType = '':@FM:'Cash_Cheque'   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-TFS.DR.ACCT.NO'     ; fieldLength = '35'     ; fieldType = 'A'                   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX-TFS.CR.ACCT.NO'     ; fieldLength = '35'     ; fieldType = 'A'                   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX>DEAL.SLIP.FMT'      ; fieldLength = '35'     ; fieldType = 'A'                   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('DEAL.SLIP.FORMAT')

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

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')

    CALL Table.addOverrideField

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*-----------------------------------------------------------------------------
END
