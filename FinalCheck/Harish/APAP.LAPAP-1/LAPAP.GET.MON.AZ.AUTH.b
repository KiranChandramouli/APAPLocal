* @ValidationCode : MjoxODE0MDYzMTY5OkNwMTI1MjoxNjgyMDY5NzkyMDc5OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:06:32
* @ValidationInfo : Encoding          : Cp1252
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
SUBROUTINE LAPAP.GET.MON.AZ.AUTH

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE           WHO                    REFERENCE            DESCRIPTION

* 21-APR-2023    Conversion tool    R22 Auto conversion        No changes
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT ;*R22 Auto conversion - END

    FN.AZ = "F.AZ.ACCOUNT"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ID = COMI

    CALL F.READ(FN.AZ,ID,R.AZ,F.AZ,ERRZ)
    AUTH = R.AZ<AZ.AUTHORISER>

    IF ERRZ THEN

        CALL F.READ(FN.ACC,ID,R.ACC,F.ACC,ERRC)
        AUTH = R.ACC<AC.AUTHORISER>
        REPLACED.AUTH = EREPLACE(AUTH, '_',@VM)
        AUTHORISER = REPLACED.AUTH<1,2>

        COMI = AUTHORISER

    END ELSE
        REPLACED.AUTH = EREPLACE(AUTH, '_',@VM)
        AUTHORISER = REPLACED.AUTH<1,2>

        COMI = AUTHORISER

    END
END
