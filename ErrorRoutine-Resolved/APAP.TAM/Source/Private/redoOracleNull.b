* @ValidationCode : MjoxODg0MzA1ODgwOkNwMTI1MjoxNjg0ODM2OTg2OTgxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:46:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE redoOracleNull(valueToCheck)   ;*R22 Manual Conversion - Changes FUNCTION to SUBROUTINE
*-----------------------------------------------------------------------------
*  REDO Oracle Date
*  Allows to check if the valueToCheckprocess is blank or null
*
*
*  Input/Output
*  ---------------
*           valueToCheck       (in)  string value to check
*
*   NULL is returned if valueToCheck is blank or null
*
*  Example
*           yValue = redoOracleNull("")
*           ;* NULL will be returned
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
*23-05-2023      HARSHA         AUTO R22 CODE CONVERSION          No changes
*23-05-2023      HARSHA         MANUAL R22 CODE CONVERSION        Changes FUNCTION to SUBROUTINE
*------------------------------------------------------------------------

    IF valueToCheck EQ '' OR NOT(valueToCheck) THEN
        RETURN 'NULL'
    END
RETURN valueToCheck
END
