* @ValidationCode : MjoxODUwMzU1NzcxOkNwMTI1MjoxNjg1NTM0MjM1OTk4OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:27:15
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
SUBROUTINE LAPAP.MON.CALC.DATE.AZ.HIS

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                 REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool       R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion -START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT ;*R22 Auto conversion - END

    FN.AZ = "F.AZ.ACCOUNT$HIS"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    ACC = COMI
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.AZ,Y.ACC.ID,R.HIS,F.AZ,ERRH)
    START.DATE = R.HIS<AZ.VALUE.DATE>
    END.DATE = R.HIS<AZ.MATURITY.DATE>

    IF ERRH EQ '' THEN
        CALL CDD("",START.DATE,END.DATE,NO.OF.DAYS)
        COMI = NO.OF.DAYS
    END ELSE
        COMI = ""
    END

RETURN
END
