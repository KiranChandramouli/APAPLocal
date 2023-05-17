* @ValidationCode : MjoxMDI0NzI2MDU2OkNwMTI1MjoxNjgyMzMxMzIyNjAwOklUU1M6LTE6LTE6Mjg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 285
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.BEN.ACC.RT

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       FM TO @FM, F.READ to CACHE.READ
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.BENEFICIARY

    Y.NUM.TXN = COMI

    GOSUB INIT
    GOSUB PROCESS

    COMI = Y.ACC.FINAL

RETURN

*---------------
INIT:
*---------------
    Y.ACC.FINAL = ''

    APPLS = 'FUNDS.TRANSFER':@FM:'BENEFICIARY'
    F.FIELDS = 'L.FT.ACH.B.ACC':@FM:'L.BEN.ACCOUNT'

    CALL MULTI.GET.LOC.REF(APPLS,F.FIELDS,POS.VAL)

    POS.ACH.B.ACC = POS.VAL<1,1>
    POS.BEN.ACCOUNT = POS.VAL<2,1>

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.BENEFICIARY = 'F.BENEFICIARY'; F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY, F.BENEFICIARY)

RETURN
*---------------
PROCESS:
*---------------
    CALL F.READ(FN.FUNDS.TRANSFER, Y.NUM.TXN, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)


    IF NOT(ERR.FT) THEN
        Y.ACH.B.ACC = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.ACH.B.ACC>
        Y.CREDIT.THEIR.REF = R.FUNDS.TRANSFER<FT.CREDIT.THEIR.REF>
        Y.BEN.ACCT.NO = R.FUNDS.TRANSFER<FT.BEN.ACCT.NO>

        IF Y.CREDIT.THEIR.REF THEN
            CALL CACHE.READ(FN.BENEFICIARY, Y.CREDIT.THEIR.REF, R.BENEFICIARY, ERR.BEN) ;*R22 Auto conversion

            IF NOT(ERR.BEN) THEN
                Y.BEN.ACCOUNT = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.BEN.ACCOUNT>

            END
        END

        IF Y.BEN.ACCOUNT THEN
            Y.ACC.FINAL = Y.BEN.ACCOUNT
        END ELSE
            IF Y.ACH.B.ACC THEN
                Y.ACC.FINAL = Y.ACH.B.ACC
            END ELSE
                IF Y.BEN.ACCT.NO THEN
                    Y.ACC.FINAL = Y.BEN.ACCT.NO
                END
            END
        END

    END

RETURN
END
