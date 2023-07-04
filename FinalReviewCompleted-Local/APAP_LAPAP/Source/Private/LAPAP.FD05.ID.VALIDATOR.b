* @ValidationCode : MjoxODA2MTIyMDEzOkNwMTI1MjoxNjg0MjIyODA4NzM0OklUU1M6LTE6LTE6OTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 99
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*24-04-2023      conversion tool     R22 Auto code conversion     No changes
*24-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.FD05.ID.VALIDATOR
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.CURRENCY

    FN.CURR = "F.CURRENCY"
    F.CURR = ""
    CALL OPF(FN.CURR,F.CURR)

    ID = V$DISPLAY

    V$DISPLAY = ID[1,3]:TODAY

    IF ID NE V$DISPLAY THEN
        E = 'INGRESE FORMATO VALIDO, [TIPO MONETA + FECHA ACTUAL] - Ejemplo: DOP20190120'
    END

    ID2 = ID[1,3]

    CALL System.setVariable('CURRENT.OLD.RECORD.ID',ID)
    CALL System.setVariable('CURRENT.OLD.RECORD.ID2',ID2)
RETURN

*DEBUG

END
