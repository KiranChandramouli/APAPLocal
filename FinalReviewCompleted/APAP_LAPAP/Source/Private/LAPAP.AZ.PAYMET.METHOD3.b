* @ValidationCode : MjoxMDU1ODkwNjEyOkNwMTI1MjoxNjg0MjIyODAyNTI5OklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   CALL routine format modified
SUBROUTINE LAPAP.AZ.PAYMET.METHOD3

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    ID = COMI
    APAP.LAPAP.lapapMonDefinePayment(ID,RS,RT) ;*R22 Manual code conversion
    IF RS EQ "FROM.CUST.ACC" THEN
        COMI = "" ;* RT
    END ELSE
        COMI = ""
    END


END
