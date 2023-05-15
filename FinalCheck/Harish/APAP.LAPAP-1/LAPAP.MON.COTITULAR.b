* @ValidationCode : MjoxNTMzNjIzMDQ0OkNwMTI1MjoxNjgyMDczOTE0NzI4OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:15:14
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
SUBROUTINE LAPAP.MON.COTITULAR

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE             WHO                  REFERENCE            DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V          R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 Auto conversion - END

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    FN.AZ = "F.AZ.ACCOUNT$HIS"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    FN.ACC.HIS = "F.ACCOUNT$HIS"
    F.ACC.HIS = ""
    CALL OPF(FN.ACC.HIS,F.ACC.HIS)

    FN.ACCOUNT.CLOSURE = "F.ACCOUNT.CLOSURE"
    F.ACCOUNT.CLOSURE = ""
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    ACC = COMI
    CALL LAPAP.VERIFY.ACC(ACC,RES)
    ID = RES

    CALL F.READ.HISTORY(FN.AZ,ID,RAZ,F.AZ,ERRZ)
    NOMINATE = RAZ<AZ.NOMINATED.ACCOUNT>

    ID = ID[1,10]
    CALL F.READ(FN.ACCOUNT.CLOSURE,ACC,R.CLOSURE,F.ACCOUNT.CLOSURE,ERR.CLOSURE)
    SETTLEMENT = R.CLOSURE<AC.ACL.SETTLEMENT.ACCT>

*  DEBUG

    IF SETTLEMENT NE '' THEN

        CALL F.READ(FN.ACC,SETTLEMENT,RCS,F.ACC,ERRC)
        CUSTOMER = RCS<AC.CUSTOMER>
        COMI = CUSTOMER

    END ELSE

        CALL F.READ(FN.ACC,NOMINATE,RCC,F.ACC,ERRCC)
        CUSTOMER = RCC<AC.CUSTOMER>
        COMI = CUSTOMER


        IF ERRCC THEN
            CALL F.READ.HISTORY(FN.ACC.HIS,NOMINATE,RCC.HIS,F.ACC.HIS,ERRCC.HIS)
            CUSTOMER = RCC.HIS<AC.CUSTOMER>
            COMI = CUSTOMER
        END


    END

*  DEBUG

RETURN

END
