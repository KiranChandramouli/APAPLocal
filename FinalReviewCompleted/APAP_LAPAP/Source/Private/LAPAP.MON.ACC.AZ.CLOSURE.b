* @ValidationCode : MjotMTczMzU0MDI4NzpDcDEyNTI6MTY4NDIyMjgxMTQzNzpJVFNTOi0xOi0xOjY4ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 688
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.ACC.AZ.CLOSURE

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE           WHO                REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 Auto conversion - END


    GOSUB INIT
    GOSUB PROCESS

INIT:
*----

    ACC = COMI

    FN.AZ = "F.AZ.ACCOUNT$HIS"
    F.AZ  = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.CLOS = "F.ACCOUNT.CLOSURE"
    F.CLOS = ""
    CALL OPF(FN.CLOS,F.CLOS)

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    CALL F.READ.HISTORY(FN.ACC,ACC,R.ACC,F.ACC,ERR);
    CALL GET.LOC.REF("ACCOUNT","L.AC.AZ.ACC.REF",POS);
    AZ.ACC.REF = R.ACC<AC.LOCAL.REF,POS>
    CATEGORY = R.ACC<AC.CATEGORY>

    IF CATEGORY GE 6010 AND CATEGORY LE 6020 THEN
        ACC = AZ.ACC.REF
    END ELSE
        ACC = ACC[1,10]
    END

RETURN

PROCESS:
*-------

    CALL F.READ.HISTORY(FN.AZ,ACC,R.AZ,F.AZ,ERRZ)
    INTEREST.LIQU.ACC = R.AZ<AZ.INTEREST.LIQU.ACCT>
    CALL GET.LOC.REF("AZ.ACCOUNT","L.TYPE.INT.PAY",POS)
    L.TYPE.INT.PAY = R.AZ<AZ.LOCAL.REF,POS>

    IF L.TYPE.INT.PAY EQ "Reinvested" THEN

        CALL F.READ(FN.CLOS,INTEREST.LIQU.ACC,R.CLOS,F.CLOS,R.CLOS)
        SETTLEMENT.ACCT = R.CLOS<AC.ACL.SETTLEMENT.ACCT>

        IF SETTLEMENT.ACCT EQ "DOP1403400010017" THEN
            COMI = "EFECTIVO"
        END ELSE
            COMI = "DEPOSITO A TERCERO"
        END

    END

    IF L.TYPE.INT.PAY EQ "Credit.To.Account" THEN

        IF INTEREST.LIQU.ACC EQ "DOP1403200170017" THEN
            COMI = "EFECTIVO"
        END ELSE
            COMI = "DEPOSITO A TERCERO"
        END

    END

    IF ERRZ THEN
        ACC = ACC[1,10]
        CALL F.READ(FN.CLOS,ACC,R.CLOS,F.CLOS,R.CLOS)
        SETTLEMENT.ACCT = R.CLOS<AC.ACL.SETTLEMENT.ACCT>

        IF SETTLEMENT.ACCT EQ "DOP1403400010017" THEN
            COMI = "EFECTIVO"
        END ELSE
            COMI = "DEPOSITO A TERCERO"
        END

    END

RETURN

END
