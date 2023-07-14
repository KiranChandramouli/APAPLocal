* @ValidationCode : MjotMzA0NjQzNjk0OkNwMTI1MjoxNjgwNzczNjY4MzgzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.FMT.OUT.PADDING
*******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.FMT.OUT.PADDING
***********************************************************************************
*Description: This routine is used to format the header with spaced as no value will be passed
*****************************************************************************
*linked with:   REDO.VISA.GEN.CHGBCK.OUT
*In parameter:  NA
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION

* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON


    GOSUB PROCESS

RETURN

********
PROCESS:
********

    BEGIN CASE

        CASE PADDING.STR EQ ''

            PAD.FMT = "R#":LEN.FIELD
            Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)

        CASE PADDING.STR EQ "0"

            PAD.FMT = "R%0":LEN.FIELD
            Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)

        CASE PADDING.STR EQ "L0"

            PAD.FMT = "L%0":LEN.FIELD
            Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)

        CASE PADDING.STR EQ "L"

            PAD.FMT = "L#":LEN.FIELD
            Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)

    END CASE



*    IF PADDING.STR EQ '' THEN
*        PAD.FMT = "R#":LEN.FIELD
*        Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)
*    END
*    IF PADDING.STR EQ 0 THEN
*        PAD.FMT = "R%0":LEN.FIELD
*        Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,PAD.FMT)
*    END


RETURN
END
