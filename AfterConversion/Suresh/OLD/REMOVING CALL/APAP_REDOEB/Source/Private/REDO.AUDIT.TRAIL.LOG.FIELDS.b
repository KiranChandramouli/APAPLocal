* @ValidationCode : MjoxOTMwNDM3NTE3OkNwMTI1MjoxNjgxOTc5NTk3Nzc5OklUU1M6LTE6LTE6LTEyOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.AUDIT.TRAIL.LOG.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AUDIT.TRAIL.LOG.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.NUMBERS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 DEC 2011   Shankar Raju          ODR-2010-03-0116          Initial Creation
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '22'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'APPLICATION'  ; fieldLength = '40'   ; fieldType = 'A' ;  GOSUB ADD.FIELDS
    fieldName = 'RECORD.ID'    ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'DATE.TIME'    ; fieldLength = '15'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'FUNCTION'     ; fieldLength = '2'    ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'XX<FIELD.NO'  ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'XX-OLD.VALUE' ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'XX>NEW.VALUE' ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'USER'         ; fieldLength = '16'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'HOST.NAME'    ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS
    fieldName = 'IP.ADDRESS'   ; fieldLength = '65'   ; fieldType = "A" ;  GOSUB ADD.FIELDS

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
