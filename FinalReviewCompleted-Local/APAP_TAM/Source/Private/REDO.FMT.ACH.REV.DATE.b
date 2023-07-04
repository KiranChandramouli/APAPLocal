* @ValidationCode : MjoxNjYwMzQ4MzQxOkNwMTI1MjoxNjg0ODQyMTAwMzkxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:40
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
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
$PACKAGE APAP.TAM
SUBROUTINE REDO.FMT.ACH.REV.DATE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.FT.REV.ID

    GREGORIAN.DATE=COMI

RETURN

END