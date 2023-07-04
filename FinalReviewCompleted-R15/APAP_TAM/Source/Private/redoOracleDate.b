* @ValidationCode : MjoxMDg3MzQ0ODIyOkNwMTI1MjoxNjg1OTUzMDIzNDY5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:47:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE redoOracleDate(yProcessValue,yDateFormat)    ;*R22 Manual Conversion - Changes FUNCTION to SUBROUTINE
*-----------------------------------------------------------------------------
*  REDO Oracle Date
*  Allows to get the processValue as representation of to_date Oracle instruction
*  using the date format
*
*  Input/Output
*  ---------------
*           yProcessValue       (in)  String to process
*           yDateFormat         (in)  Oracle Date format, for example yyyyMMdd
*   NULL is returned if yProcessValue is blank or null
*
*  Example
*           yValue = redoOracleDate("20101121","yyyyMMdd")
*           ;* to_date('20101121','yyyyMMdd') will be returned
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
*23-05-2023      HARSHA         AUTO R22 CODE CONVERSION          No changes
*23-05-2023      HARSHA         MANUAL R22 CODE CONVERSION        Changes FUNCTION to SUBROUTINE
*------------------------------------------------------------------------

    DEFFUN redoOracleNull()
    IF yProcessValue EQ '' THEN
        RETURN redoOracleNull(yProcessValue)
    END
    Y.FORMAT = "to_date('" : yProcessValue : "','" : yDateFormat : "')"
RETURN Y.FORMAT
END
