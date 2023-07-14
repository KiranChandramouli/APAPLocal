* @ValidationCode : Mjo1MTIyMTU5ODM6Q3AxMjUyOjE2ODgzNjE0NDk5Njk6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jul 2023 10:47:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*03/07/2023                    VIGNESHWARI              MANUAL R22 CODE CONVERSION             T24.BP is removed in insertfile
*03/07/2023                 CONVERSION TOOL             AUTO R22 CODE CONVERSION               NOCHANGE
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
