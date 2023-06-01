* @ValidationCode : MjotNzYxNTE2NDE1OkNwMTI1MjoxNjg1NTMyOTgyMDk4OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   CALL routine format modified
SUBROUTINE LAPAP.AZ.PAYMET.METHOD2

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    ID = COMI
    APAP.LAPAP.lapapMonDefinePayment(ID,RS,RT) ;*R22 Manual code conversion
    IF RS EQ "CHEQUE.DEPOSIT" THEN
        COMI = RT
    END ELSE
        COMI = ""
    END

END
