* @ValidationCode : Mjo5NjUyMjY0Nzk6Q3AxMjUyOjE2ODU1MzQxODk2NjE6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:26:29
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
SUBROUTINE LAPAP.MON.AZ.GET.PROMOTOR.HIS
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP removed in INSERT file
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END


    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ACC = COMI
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.ACC,ACC,R.HIS,F.ACC,ERRH)
    PROMOTOR = R.HIS<AC.ACCOUNT.OFFICER>

    COMI = PROMOTOR

RETURN

END
