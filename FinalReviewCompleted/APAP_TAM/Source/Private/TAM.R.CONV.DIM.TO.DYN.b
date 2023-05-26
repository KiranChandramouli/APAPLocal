* @ValidationCode : MjotMTQwNjI3NTUyOkNwMTI1MjoxNjg0ODQyMTU2MzQzOklUU1M6LTE6LTE6LTE3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -17
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.R.CONV.DIM.TO.DYN(MAT recordIn, length, recordOut)
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @description Allows to convert the DIM variable to an dynamic array
* @parameters
*          recordIn      (in)        Dimension variable to convert
*          length        (in)        How many entries in recordIn will be converted to recordOut
*          recordOut     (out)       output
*          E             (out)       Common variable with message in case of Error

** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    IF E NE "" THEN
        RETURN
    END
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    recordOut = ""
    FOR yPos = 1 TO length
        recordOut<yPos> = recordIn(yPos)
    NEXT yPos

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
* Parameter Validations
    IF length EQ "" THEN
        E = "Parameter length is required"
        RETURN
    END
    IF length LT 0 THEN
        E = "Parameter length must be greater than 0"
        RETURN
    END
    IF length GT C$SYSDIM THEN
        E = "Parameter length must be less than " : C$SYSDIM
        RETURN
    END

* TODO: how to validate the lenght of the DIM variable
RETURN

*-----------------------------------------------------------------------------
END
