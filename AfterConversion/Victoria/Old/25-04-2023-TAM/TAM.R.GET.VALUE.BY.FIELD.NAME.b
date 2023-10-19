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
    CALL TAM.BP.TAM.R.FIELD.NAME.TO.NUMBER(tableName, fieldName, fieldNo)
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
