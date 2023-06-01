* @ValidationCode : MjotMTUwODc4OTg0NDpDcDEyNTI6MTY4NTUzMzk5NTMxMjpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:23:15
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
*24-04-2023      conversion tool     R22 Auto code conversion     No changes
*24-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.GET.CUS.NAME
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ACC = COMI
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.ACC,Y.ACC.ID,R.ACC,F.ACC,ERRAC)
    CUSTOMER = R.ACC<AC.CUSTOMER>

    CALL F.READ(FN.CUS,CUSTOMER,R.CUS,F.CUS,ERC)
    CUS = R.CUS<EB.CUS.SHORT.NAME>

    COMI = CUS

END
