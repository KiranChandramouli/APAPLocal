* @ValidationCode : MjotMTIwNDI3OTQ5OkNwMTI1MjoxNjgyMzMxMzIyNjc4OklUU1M6LTE6LTE6Mjg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
SUBROUTINE L.APAP.GET.BEN.NAME.RT

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.BENEFICIARY

    Y.NUM.TXN = COMI

    GOSUB INIT
    GOSUB PROCESS

    COMI = Y.NAME.FINAL

RETURN

*---------------
INIT:
*---------------
    Y.NAME.FINAL = ''

    APPLS = 'FUNDS.TRANSFER':@FM:'BENEFICIARY'
    F.FIELDS = 'L.FT.ACH.B.NAM':@FM:'L.BEN.CUST.NAME'

    CALL MULTI.GET.LOC.REF(APPLS,F.FIELDS,POS.VAL)

    POS.FT.ACH.B.NAM = POS.VAL<1,1>
    POS.BEN.NAME = POS.VAL<2,1>

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
        Y.ACH.B.NAM = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.FT.ACH.B.NAM>
        Y.CREDIT.THEIR.REF = R.FUNDS.TRANSFER<FT.CREDIT.THEIR.REF>
        Y.BEN.CUSTOMER = R.FUNDS.TRANSFER<FT.BEN.CUSTOMER>
        Y.BEN.CUSTOMER = CHANGE(Y.BEN.CUSTOMER,@VM,@FM)
        Y.BEN.CUSTOMER = CHANGE(Y.BEN.CUSTOMER,@SM,@FM)
        Y.BEN.CUSTOMER = Y.BEN.CUSTOMER<1>

        IF Y.CREDIT.THEIR.REF THEN
            CALL CACHE.READ(FN.BENEFICIARY, Y.CREDIT.THEIR.REF, R.BENEFICIARY, ERR.BEN) ;*R22 Auto conversion

            IF NOT(ERR.BEN) THEN
                Y.NAME.BEN = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.BEN.NAME>
            END
        END

        IF Y.NAME.BEN THEN
            Y.NAME.FINAL = Y.NAME.BEN
        END ELSE
            IF Y.ACH.B.NAM THEN
                Y.NAME.FINAL = Y.ACH.B.NAM
            END ELSE
                IF Y.BEN.CUSTOMER THEN
                    Y.NAME.FINAL = Y.BEN.CUSTOMER
                END
            END
        END

    END

RETURN
END
