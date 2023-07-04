* @ValidationCode : Mjo4MDYwNjA3NTI6Q3AxMjUyOjE2ODEzODA5NDk0NTk6YWppdGg6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:45:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.LOAN.CHEQUE.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.LOAN.CHEQUE.DETAILS.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.APAP.LOAN.CHEQUE.DETAILS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 7th JUN 2010    Mohammed Anies K   ODR-2009-10-1678 B.10      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX<TRANS.REF'           ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX<CHQ.NO'           ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-IN.TRANSIT.DAYS'  ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-TRANSIT.RELEASE'  ; fieldLength = '35'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.COUNT'    ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.DATE'     ; fieldLength = '35'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.AMT'      ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX>XX>CHQ.STATUS'       ; fieldLength = '10'   ; fieldType = "":@FM:"REATAINED_DROPPED"  ;  GOSUB ADD.FIELDS

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------------------------------------------------------------
END
