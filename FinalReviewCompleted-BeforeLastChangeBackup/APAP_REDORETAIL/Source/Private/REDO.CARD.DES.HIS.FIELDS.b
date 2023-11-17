* @ValidationCode : Mjo5MjAzODIzNTU6Q3AxMjUyOjE2ODE4MjgwMDM1ODQ6SVRTUzotMTotMTotMTM6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.DES.HIS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DES.HIS.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.DES.HIS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 16 July 2010    Mohammed Anies K      ODR-2010-03-0400         Initial Creation
* 17-MAY-2011       KAVITHA             ODR-2010-08-0467        PACS00056667  FIX
* 11-04-2023      CONVERSION TOOL      AUTO R22 CODE CONVERSION      NO CHANGES
* 11-04-2023      jayasurya H          MANUAL R22 CODE CONVERSION    NO CHANGES
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '25'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'CARD.TYPE'; fieldLength = '5'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'CARD.START.NO' ; fieldLength = '15'   ; fieldType = ''  ;  GOSUB ADD.FIELDS

    fieldName = 'DATE.RECD.BRANCH' ; fieldLength = '8'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'QTY.RECEIVED' ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'DEST.DATE' ; fieldLength = '8'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS

    fieldName = 'XX.CARD.NUMBER' ; fieldLength = '16'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'PLASTIC.STATUS' ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'DESTROY.QTY' ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS

    neighbour = ''
    fieldName = 'AGENCY'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COMPANY')


    CALL Table.addReservedField('RESERVED.17')
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
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
