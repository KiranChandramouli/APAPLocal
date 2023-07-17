* @ValidationCode : MjoyOTUxMDQ5MjY6Q3AxMjUyOjE2ODQyMjI4MDY3MTU6SVRTUzotMTotMToxMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.CUSTOMER.EMPLOYMENT.STATUS

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.CUSTOMER

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    EMPLOYMENT.STATUS = COMI

    IF EMPLOYMENT.STATUS EQ 04 OR EMPLOYMENT.STATUS EQ 62 THEN
        ETEXT = "VALOR NO VALIDO"
        CALL STORE.END.ERROR
    END

RETURN

END
