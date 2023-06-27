* @ValidationCode : MjotMTk0NjAxODI1NDpDcDEyNTI6MTY4NDIyNjQxMTY5OTpJVFNTOi0xOi0xOjE5OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 14:10:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 199
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.SALD.HIS

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool    R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V        R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ACC = COMI
    CALL APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.ACC,Y.ACC.ID,R.HIS,F.ACC,ERRH)
    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",POS)
    SALDO = R.HIS<AC.LOCAL.REF,POS>
    COMI = SALDO

RETURN

END
