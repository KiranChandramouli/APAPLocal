* @ValidationCode : MjotMTY5MjEyMTcxNDpVVEYtODoxNjg5NTc0MTk4Mjc2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Jul 2023 11:39:58
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.CUS.MAN.MAN.RT

*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,REM to DISPLAY.MESSAGE(TEXT, '')
* 17-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.LY.POINT.MAN
    $INSERT I_F.CUSTOMER ;*R22 Auto Conversion -END

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    Y.CUS.ID = R.NEW(ST.LAPLY.CODIGO.CLIENTE)
    IF Y.CUS.ID NE '' THEN
        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,ERR.MDDE11)

        IF R.CUS EQ '' THEN
            TEXT = 'CODIGO CLIENTE INVALIDO.'
            CALL DISPLAY.MESSAGE(TEXT, '') ;*R22 Auto Conversion
            E = TEXT
            CALL STORE.END.ERROR
        END
    END

END
