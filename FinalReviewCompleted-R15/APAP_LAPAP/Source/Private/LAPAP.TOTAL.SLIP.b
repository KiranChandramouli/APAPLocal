* @ValidationCode : MjotMTk3NDM4MDc3OkNwMTI1MjoxNjg2Njc0MjY2MDUwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*12-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*12-06-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.TOTAL.SLIP(Y.INP.DEAL)
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY ;*R22 AUTO CONVERSION END

    GOSUB PROCESS
RETURN

PROCESS:
    GOSUB OPEN.TABLE:
    GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")

    IF GET.TXN.ID EQ 'CURRENT.WTM.FIRST.ID' THEN
        GET.TXN.ID = ID.NEW:'-NV.INFO'
    END ELSE
        GET.TXN.ID = GET.TXN.ID:'-NV.INFO'
    END

    READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID THEN
        IF R.REDO.CASHIER.DEALSLIP.INFO NE '' OR R.REDO.CASHIER.DEALSLIP.INFO NE 0 THEN
            R.DEAL.ARRAY = R.REDO.CASHIER.DEALSLIP.INFO
        END
    END

    LOCATE ID.NEW IN R.DEAL.ARRAY<1,1> SETTING POS1 THEN
        GOSUB GET.VALUES
    END

RETURN
OPEN.TABLE:
    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''
    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

RETURN

GET.VALUES:
    Y.TOTAL.PAGADO = R.DEAL.ARRAY<6,POS1>
    Y.INP.DEAL = FMT(Y.TOTAL.PAGADO,"18R,2")

RETURN

END
