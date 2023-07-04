* @ValidationCode : MjoyMTMwNDE2Mzk4OkNwMTI1MjoxNjg4NDU2NDIxNDgxOklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jul 2023 13:10:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*03/07/2023                    VIGNESHWARI������        MANUAL R22 CODE CONVERSION             T24.BP is removed in insertfile
*03/07/2023                 CONVERSION TOOL��������     AUTO R22 CODE CONVERSION               Insert commented - I_F.ST.LAPAP.LY.POINT.MAN
*-----------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.V.CUS.MAN.MAN.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
*    $INSERT BP I_F.ST.LAPAP.LY.POINT.MAN
    $INSERT  I_F.CUSTOMER

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    Y.CUS.ID = R.NEW(ST.LAPLY.CODIGO.CLIENTE)
    IF Y.CUS.ID NE '' THEN
        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,ERR.MDDE11)

        IF R.CUS EQ '' THEN
            TEXT = 'CODIGO CLIENTE INVALIDO.'
            CALL REM
            E = TEXT
            CALL STORE.END.ERROR
        END
    END

END
