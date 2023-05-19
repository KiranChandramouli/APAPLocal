* @ValidationCode : Mjo1NjA0NTI0MDc6Q3AxMjUyOjE2ODQzOTgzMDU0MzM6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 May 2023 13:55:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*----------------------------------------------------------------------------------------
SUBROUTINE TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, fieldName, MAT recSource, fieldValue, fieldNo)
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @description Allows to get the field from DIM array, using the fieldName instead of the fieldNo
*              the routine tries to return the value and its position
* @example
*           CALL TAM.R.GET.VALUE.BY.FIELD.NAME("CUSTOMER","SECTOR", R.NEW, fieldValue)
* If the value does not exists, fieldValue with "" will be returned and fieldNo will be assigned with 0
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*CALL TAM.R.FIELD.NAME.TO.NUMBER(tableName, fieldName, fieldNo)
*R22 MANUAL CONVERSION
*CALL TAM.BP.TAM.R.FIELD.NAME.TO.NUMBER(tableName, fieldName, fieldNo) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.TamRFieldNameToNumber(tableName, fieldName, fieldNo) ;*R22 MANUAL CODE CONVERSION
    IF fieldNo GT 0 THEN
        fieldValue = recSource(fieldNo)
    END

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
    fieldNo = 0
    fieldValue = ""
RETURN

*-----------------------------------------------------------------------------
END
