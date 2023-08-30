* @ValidationCode : Mjo2NzM0ODQyMjE6Q3AxMjUyOjE2ODI0MDQzMzA4NTI6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 12:02:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.AZ.PAYMET.METHOD2

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    ID = COMI
    CALL APAP.LAPAP.LAPAP.MON.DEFINE.PAYMENT(ID,RS,RT)
    IF RS EQ "CHEQUE.DEPOSIT" THEN
        COMI = RT
    END ELSE
        COMI = ""
    END

END
