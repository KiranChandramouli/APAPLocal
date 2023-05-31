* @ValidationCode : MjotMTgzNDY3MzY5MDpDcDEyNTI6MTY4NTUzNDA4MTE3NDpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:24:41
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
SUBROUTINE LAPAP.GET.MON.AZ.AUTH.HIS

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO                 REFERENCE                DESCRIPTION

* 21-APR-2023   Conversion tool      R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V          R22 Manual Conversion    CALL method format changed

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;*R22 Auto conversion - END

    FN.AZ = "F.AZ.ACCOUNT$HIS"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    ACC = COMI
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.AZ,Y.ACC.ID,R.HIS,F.AZ,ERRH)
    AUTH = R.HIS<AZ.AUTHORISER>

    REPLACED.AUTH = EREPLACE(AUTH, '_',@VM)
    AUTHORISER = REPLACED.AUTH<1,2>

    COMI = AUTHORISER
RETURN

END
