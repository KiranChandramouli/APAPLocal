* @ValidationCode : Mjo2OTI4NzM2NzY6Q3AxMjUyOjE2ODQyMjQ5OTQ2Njg6SVRTUzotMTotMToxOTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:46:34
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
SUBROUTINE LAPAP.MON.INTEREST.RATE

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO                 REFERENCE                   DESCRIPTION

* 21-APR-2023 Conversion tool       R22 Auto conversion        BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion      No Changes
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
    INTEREST = R.HIS<AZ.INTEREST.RATE>

    COMI = INTEREST

END
