* @ValidationCode : MjotMTA0ODE4NTI3ODpDcDEyNTI6MTY4MTgyODAwNTg4MTpJVFNTOi0xOi0xOi0xMzoxOnRydWU6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.REORDER.DEST.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REORDER.DEST.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.REORDER.DEST
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 16 May 2011        jeeva T            PACS00036010           Adding two fields PREEMB.DEST.DAYS & PERS.DEST.DAYS
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
    ID.CHECKFILE='COMPANY'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'XX<CARD.TYPE'; fieldLength = '15'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CARD.TYPE')
    fieldName = 'XX-CARD.SERIES' ; fieldLength = '5'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-REORDER.LEVEL' ; fieldLength = '15'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-REORDER.QTY' ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-PREEMB.DEST.DAYS' ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-PERS.DEST.DAYS' ; fieldLength = '10'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX>REMARKS' ; fieldLength = '50'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS

    CALL Table.addReservedField('RESERVED.19')
    CALL Table.addReservedField('RESERVED.18')
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
